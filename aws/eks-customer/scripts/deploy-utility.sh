#!/usr/bin/env bash

set -o errexit

source $(dirname "$0")/utils.sh

utilities_json=$1

function add_cluster(){
  echo "Adding cluster to cluster-values.yaml"
  
	cluster_exists=$(yq eval ".clusters[] | select(.name == \"${CLUSTER_NAME}\")" $cluster_yaml)

    if [ -z "$cluster_exists" ]; then
        yq eval ".clusters += [{
            \"name\": \"${CLUSTER_NAME}\",
            \"type\": \"eks\",
            \"labels\": {
                    \"cluster-type\": \"customer\",
                    \"cluster-id\": \"${CLUSTER_NAME}\"
            },
            \"api_server\": \"${API_SERVER}\",
            \"clusterName\": \"${CLUSTER_NAME}\",
            \"argoCDRoleARN\": \"${ARGOCD_ROLE_ARN}\",
            \"caData\": \"${CA_DATA}\"
        }]" -i $cluster_yaml
    else
      # Update the cluster if it already exists
      yq eval "(.clusters[] | select(.name == \"${CLUSTER_NAME}\") | .labels."cluster-type") = \"customer\"" -i $cluster_yaml
      yq eval "(.clusters[] | select(.name == \"${CLUSTER_NAME}\") | .labels."cluster-id") = \"${CLUSTER_NAME}\"" -i $cluster_yaml
      yq eval "(.clusters[] | select(.name == \"${CLUSTER_NAME}\") | .api_server) = \"${API_SERVER}\"" -i $cluster_yaml
      yq eval "(.clusters[] | select(.name == \"${CLUSTER_NAME}\") | .argoCDRoleARN) = \"${ARGOCD_ROLE_ARN}\"" -i $cluster_yaml
      yq eval "(.clusters[] | select(.name == \"${CLUSTER_NAME}\") | .caData) = \"${CA_DATA}\"" -i $cluster_yaml
      echo "Cluster already exists, updating the cluster."
    fi
  
  echo "Commiting changes: Adding cluster ${CLUSTER_NAME}"
  stage_changes $cluster_yaml
  commit_changes "Adding cluster: ${CLUSTER_NAME}" $cluster_yaml
}

function create_cluster_folder() {
	echo "Creating custom values file"
	mkdir $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME} || true
}

function deploy_utility() {
  echo $utilities_json | jq -c '.[]' | while read -r utility; do
		utility_name=$(echo "$utility" | jq -r '.name')
    cluster_label_type=$(echo "$utility" | jq -r '.cluster_label_type')

    add_utility_to_application_file $utility_name $cluster_label_type
    replace_custom_values $utility_name
    replace_custom_manifests $utility_name
    commit_changes "CLUSTER_NAME: ${CLUSTER_NAME} Adding utility ${utility_name}" $application_yaml
    # wait_for_healthy $utility_name

	done

  # PUSH_UTILITIES_TO_MAIN if this value is set to true, then push the changes to main
  if [[ $PUSH_UTILITIES_TO_MAIN == "false" ]]; then
    push_changes_to_git $BRANCH_NAME
    make_pr $BRANCH_NAME
  else
    push_changes_to_git "main"
  fi
}

function add_utility_to_application_file() {
	utility_name=$1
  cluster_label_type=$2
  echo "Adding utility ${utility_name} to application-values.yaml"

  if [[ -f $application_yaml && $cluster_label_type != "customer" ]]; then
      CLUSTER_NAME_exists=$(yq eval ".applications[] | select(.name == \"$utility_name\") | .cluster_labels | select(.[] | .\"cluster-id\" == \"${CLUSTER_NAME}\")" $application_yaml)
      if [[ -z $CLUSTER_NAME_exists ]]; then
          yq eval "(.applications[] | select(.name == \"$utility_name\") | .cluster_labels) += [{\"cluster-id\": \"${CLUSTER_NAME}\"}]" -i $application_yaml
      fi
  fi

  stage_changes $application_yaml
}

function replace_custom_values () {
  echo "Replacing custom values"
  utility_name=$1

  file_path="$gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml"
  template_path="$gitops_apps_dir/custom-values-template/$utility_name-custom-values.yaml-template"

  replace_file_values "$file_path" "$template_path" "$utility_name"
}

function replace_custom_manifests () {
  echo "Replacing custom manifests"
  utility_name=$1

  file_path="$gitops_apps_dir/${ENV}/manifests/${CLUSTER_NAME}/$utility_name/$utility_name-custom-manifest.yaml"
  template_path="$gitops_apps_dir/custom-manifests-template/$utility_name-custom-manifest.yaml-template"

  replace_file_values "$file_path" "$template_path" "$utility_name"
}

function replace_file_values () {
  echo "Replacing custom values"
  local file_path=$1
  local template_path=$2
  local utility_name=$3

  certificate_arn=$(escape_string ${CERTIFICATE_ARN})
  private_certificate_arn=$(escape_string ${PRIVATE_CERTIFICATE_ARN})
  allow_list_cidr_range=$(escape_string ${ALLOW_LIST_CIDR_RANGE})

  target_dir=$(dirname "$file_path")
  if [[ ! -d "$target_dir" ]]; then
    echo "Directory $target_dir does not exist. Creating it."
    mkdir -p "$target_dir" || { echo "Failed to create directory $target_dir"; return 1; }
  fi

  if [[ -f "$template_path" ]]; then
    cp "$template_path" "$file_path" || { echo "Failed to copy template to $file_path"; return 1; }
    sed -i -z -e "s/<CLUSTER_ID>/${CLUSTER_NAME}/g" \
              -e "s/<ENV>/${ENV}/g" \
              -e "s/<AWS_ACCOUNT>/${AWS_ACCOUNT}/g" \
              -e "s/<CERTIFICATE_ARN>/$certificate_arn/g" \
              -e "s/<PRIVATE_CERTIFICATE_ARN>/$private_certificate_arn/g" \
              -e "s/<VPC_ID>/${VPC_ID}/g" \
              -e "s/<PRIVATE_DOMAIN>/${PRIVATE_DOMAIN}/g" \
              -e "s/<IP_RANGE>/$allow_list_cidr_range/g" \
              -e "s/hostNetwork: false/hostNetwork: true/g" \
              -e "s/hostNetwork:\n  enabled: false/hostNetwork:\n  enabled: true/" "$file_path" || { echo "Failed to replace values in $file_path"; return 1; }

    stage_changes "$file_path"
  fi
}

# function replace_custom_values () {
#   echo "Replacing custom values"
# 	utility_name=$1

#   certificate_arn=$(escape_string ${CERTIFICATE_ARN})
#   private_certificate_arn=$(escape_string ${PRIVATE_CERTIFICATE_ARN})
#   allow_list_cidr_range=$(escape_string ${ALLOW_LIST_CIDR_RANGE})

#   if [[ -f "$gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml" ]]; then
#     echo "Custom values file already exists, skipping"
#     return
#   fi

#   if [[  -f $gitops_apps_dir/custom-values-template/$utility_name-custom-values.yaml-template ]]; then
#     cp $gitops_apps_dir/custom-values-template/$utility_name-custom-values.yaml-template $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
#     sed -i -z -e "s/<CLUSTER_ID>/${CLUSTER_NAME}/g" \
#               -e "s/<ENV>/${ENV}/g" \
#               -e "s/<CLUSTER_ID>/${CLUSTER_NAME}/g" \
#               -e "s/<AWS_ACCOUNT>/${AWS_ACCOUNT}/g" \
#               -e "s/<CERTIFICATE_ARN>/$certificate_arn/g" \
#               -e "s/<PRIVATE_CERTIFICATE_ARN>/$private_certificate_arn/g" \
#               -e "s/<VPC_ID>/${VPC_ID}/g" \
#               -e "s/<PRIVATE_DOMAIN>/${PRIVATE_DOMAIN}/g" \
#               -e "s/<IP_RANGE>/$allow_list_cidr_range/g" \
#               -e "s/hostNetwork: false/hostNetwork: true/g" \
#               -e "s/hostNetwork:\n  enabled: false/hostNetwork:\n  enabled: true/" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml

#     stage_changes $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
#   fi

# }

function wait_for_healthy() {
  utility_name=$1
  utility_app_name=$utility_name-sre-${CLUSTER_NAME}

  if [[ -z $ARGOCD_API_TOKEN ]]; then
    echo "ARGOCD_API_TOKEN is not set"
    exit 1
  fi

  while true; do
    status=$(curl -s "https://${ARGOCD_SERVER}/api/v1/applications/${utility_app_name}?refresh=true" --cookie "argocd.token=$ARGOCD_API_TOKEN" | jq -r '.status.health.status')

    echo "Application $utility_app_name status: $status"

    if [[ $status == "Healthy" || $status == "Degraded" ]]; then #Degraded is also considered healthy in this context
      echo "Application $utility_app_name is healthy"
      break
    fi

    sleep 10
  done
}

function main() {
  clone_repo
  if [[ $PUSH_UTILITIES_TO_MAIN == "false" ]]; then
    create_new_branch $BRANCH_NAME
  fi
  add_cluster
  create_cluster_folder
  deploy_utility
  clean_up
}

main
