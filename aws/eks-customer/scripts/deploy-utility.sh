#/usr/bin/env bash

set -e -x

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
    commit_changes "CLUSTER_NAME: ${CLUSTER_NAME} Adding utility ${utility_name}" $application_yaml
    wait_for_healthy $utility_name

	done

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

  certificate_arn=$(escape_string ${CERTIFICATE_ARN})
  private_certificate_arn=$(escape_string ${PRIVATE_CERTIFICATE_ARN})
  allow_list_cidr_range=$(escape_string ${ALLOW_LIST_CIDR_RANGE})

  if [[  -f $gitops_apps_dir/custom-values-template/$utility_name-custom-values.yaml-template ]]; then
    cp $gitops_apps_dir/custom-values-template/$utility_name-custom-values.yaml-template $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<CLUSTER_ID>/${CLUSTER_NAME}/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<ENV>/${ENV}/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<CLUSTER_ID>/${CLUSTER_NAME}/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<CERTFICATE_ARN>/$certificate_arn/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<PRIVATE_CERTIFICATE_ARN>/$private_certificate_arn/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<VPC_ID>/${VPC_ID}/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<PRIVATE_DOMAIN>/${PRIVATE_DOMAIN}/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/<IP_RANGE>/$allow_list_cidr_range/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
    sed -i "s/hostNetwork: false/hostNetwork: true/g" $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml

    stage_changes $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}/$utility_name-custom-values.yaml
  fi

}

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
  add_cluster
  create_cluster_folder
  deploy_utility
  clean_up
}

main
