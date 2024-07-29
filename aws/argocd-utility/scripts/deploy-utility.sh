#/usr/bin/env bash

set -e -x

source $(dirname "$0")/utils.sh

utilities_json=$1
gitops_dir="gitops-sre/apps"
application_yaml="$gitops_dir/${ENV}/application-values.yaml"
cluster_yaml="gitops-sre/clusters/${ENV}/cluster-values.yaml"

function clone_repo() {
    echo "Cloning repo $GIT_REPO_URL"
    if [ -z "$GIT_REPO_URL" ]; then
        echo "Git URL is empty"
        exit 1
    fi
    if [ -d "gitops-sre" ]; then
        echo "Directory gitops-sre already exists"
    else
        git clone $GIT_REPO_URL gitops-sre
    fi
}

function add_cluster(){
  echo "Adding cluster to cluster-values.yaml"
	base64_ca_data=$(echo $CA_DATA | base64)
	cluster_exists=$(yq eval ".clusters[] | select(.name == \"${CLUSTER_NAME}\")" $cluster_yaml)

    if [ -z "$cluster_exists" ]; then
        yq eval ".clusters += [{
            \"name\": \"${CLUSTER_NAME}\",
            \"type\": \"eks\",
            \"labels\": {
                    \"cluster-id\": \"${CLUSTER_ID}\"
            },
            \"api_server\": \"${API_SERVER}\",
            \"clusterName\": \"${CLUSTER_NAME}\",
            \"argoCDRoleARN\": \"${ARGOCD_ROLE_ARN}\",
            \"caData\": \"$base64_ca_data\"
        }]" -i $cluster_yaml
    fi
  
  echo "Commiting changes: Adding cluster ${CLUSTER_NAME}"
  stage_changes $cluster_yaml
  commit_changes "Adding cluster: ${CLUSTER_ID}" $cluster_yaml
}

function create_cluster_folder() {
	echo "Creating custom values file"
	mkdir $gitops_dir/${ENV}/helm-values/${CLUSTER_ID} || true
}

function deploy_utility() {
  # Debug: print the JSON to check if it's correctly passed
  echo "Received JSON: $utilities_json"

  echo $utilities_json | jq -c '.[]' | while read -r utility; do
		utility_name=$(echo "$utility" | jq -r '.name')
    echo UTILITY_NAME: $utility_name

    add_utility_to_application_file $utility_name
    replace_custom_values $utility_name

  commit_changes "cluster_id: ${CLUSTER_ID} Adding utility ${utility_name}" $application_yaml

	done
}

function add_utility_to_application_file() {
  echo "Adding utility to application-values.yaml"
	utility_name=$1

  if [[ -f $application_yaml ]]; then
      cluster_id_exists=$(yq eval ".applications[] | select(.name == \"$utility_name\") | .cluster_labels | select(.[] | .\"cluster-id\" == \"${CLUSTER_ID}\")" $application_yaml)
      if [[ -z $cluster_id_exists ]]; then
          yq eval "(.applications[] | select(.name == \"$utility_name\") | .cluster_labels) += [{\"cluster-id\": \"${CLUSTER_ID}\"}]" -i $application_yaml
      fi
  fi

  stage_changes $application_yaml
}

function replace_custom_values () {
  echo "Replacing custom values"
	utility_name=$1

  cp $gitops_dir/custom-values-template/$utility_name-custom-values.yaml-template $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml

  certificate_arn=$(escape_string ${CERTIFICATE_ARN})
  private_certificate_arn=$(escape_string ${PRIVATE_CERTIFICATE_ARN})

	sed -i '' "s/<CLUSTER_ID>/${CLUSTER_ID}/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<ENV>/${ENV}/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<CLUSTER_NAME>/${CLUSTER_NAME}/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<CERTFICATE_ARN>/$certificate_arn/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<PRIVATE_CERTIFICATE_ARN>/$private_certificate_arn/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<VPC_ID>/${VPC_ID}/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<PRIVATE_DOMAIN>/${PRIVATE_DOMAIN}/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
	sed -i '' "s/<IP_RANGE>/${IP_RANGE}/g" $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml

  echo "Commiting changes: Create custom-values file for utility ${utility_name}"
  stage_changes $gitops_dir/${ENV}/helm-values/${CLUSTER_ID}/$utility_name-custom-values.yaml
}

function main() {
  clone_repo
  add_cluster
  create_cluster_folder
  deploy_utility
  push_changes_to_git
  remove_gitops_dir
}

main