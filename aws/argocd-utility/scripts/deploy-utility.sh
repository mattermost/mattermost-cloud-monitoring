#/usr/bin/env bash

utility_name=$1
gitops_dir="gitops-sre/apps"
application_yaml="$gitops_dir/application-values.yaml"


function add_utility_to_application_file() {
    echo "Adding utility to application-values.yaml"
    if [[ -f $application_yaml ]]; then
        cluster_id_exists=$(yq eval ".applications[] | select(.name == \"$utility_name\") | .cluster_labels | select(.[] | .\"cluster-id\" == \"${CLUSTER_ID}\")" $application_yaml)
        if [[ -z $cluster_id_exists ]]; then
            yq eval "(.applications[] | select(.name == \"$utility_name\") | .cluster_labels) += [{\"cluster-id\": \"${CLUSTER_ID}\"}]" -i $application_yaml
        fi
    fi
}

function create_cluster_folder() {
    echo "Creating custom values file"
    mkdir $gitops_dir/${ENV}/helm-values/${CLUSTER_ID} || true
}

function escape_string() {
    local input="$1"
    local escaped=$(printf '%s' "$input" | sed 's/[\/&]/\\&/g; s/-/\\-/g')
    echo "$escaped"
}

function replace_custom_values () {
    echo "Replacing custom values"
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
}


function main() {
    add_utility_to_application_file
    create_cluster_folder
    replace_custom_values
}

main