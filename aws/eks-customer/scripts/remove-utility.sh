#!/usr/bin/env bash

set -o errexit

source $(dirname "$0")/utils.sh

echo "REMOVE UTILITY FROM GITOPS REPO"

function delete_utility_from_argocd() {
  echo $utilities_json | jq -c '.[]' | while read -r utility; do
    utility_name=$(echo "$utility" | jq -r '.name')
    echo "Deleting utility ${utility_name} from argocd"
    if [[ -z $ARGOCD_API_TOKEN ]]; then
      echo "ARGOCD_API_TOKEN is not set"
      exit 1
    fi
    argocd_utility_name="${utility_name}-sre-${ENV}-${CLUSTER_NAME}"
    argocd_delete $argocd_utility_name
  done
}

function argocd_delete() {
  echo "Deleting utilities from argocd"
  argocd_utility_name=$1
  
  while true; do
    status=$(curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: application/json' -X "DELETE" "https://${ARGOCD_SERVER}/api/v1/applications/${argocd_utility_name}?cascade=false&propagationPolicy=orphan" --cookie "argocd.token=$ARGOCD_API_TOKEN")
    if [[ $status -eq 200 ]]; then
      echo "Utility ${argocd_utility_name} deleted successfully"
      break
    else
      echo "Utility ${argocd_utility_name} deletion failed with status code ${status}"
      sleep 5
    fi
  done
}

function remove_utilities() {
    yq eval -i "(.applications[].cluster_labels[] | select(.[\"cluster-id\"] == \"${CLUSTER_NAME}\")) = null | del(.applications[].cluster_labels[] | select(. == null))" $application_yaml
    stage_changes $application_yaml
}


function remove_helm_values() {
    if [ -d $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME} ]; then
        echo "Removing helm values for cluster ${CLUSTER_NAME}"
        rm -rf $gitops_apps_dir/${ENV}/helm-values/${CLUSTER_NAME}
        stage_changes $gitops_apps_dir/${ENV}/helm-values
        echo "Commiting changes: Adding cluster ${CLUSTER_NAME}"
        commit_changes "Remove utilities: ${CLUSTER_NAME}" $gitops_apps_dir/${ENV}/helm-values
    else
      echo "No helm values found for cluster ${CLUSTER_NAME}"
    fi
}


function wait_for_argocd() {
  echo "Waiting for argocd to sync"
  sleep 180
}

function remove_cluster() {
    yq eval -i "del(.clusters[] | select(.name == \"${CLUSTER_NAME}\"))" $cluster_yaml
    stage_changes $cluster_yaml
    commit_changes "Removing cluster: ${CLUSTER_NAME}" $cluster_yaml
}

function main() {
  clone_repo
  delete_utility_from_argocd
  remove_utilities
  remove_helm_values
  wait_for_argocd
  remove_cluster
  clean_up
}

main
