#/usr/bin/env bash

set -e -x

source $(dirname "$0")/utils.sh

echo "REMOVE UTILITY FROM GITOPS REPO"

function remove_utilities() {
    yq eval -i "(.applications[].cluster_labels[] | select(.[\"cluster-id\"] == \"${CLUSTER_NAME}\")) = null | del(.applications[].cluster_labels[] | select(. == null))" $application_yaml
    stage_changes $application_yaml
}

function remove_helm_values() {
    rm -rf $gitops_dir/${ENV}/helm-values/${CLUSTER_NAME}
    stage_changes $gitops_dir/${ENV}/helm-values
}

function commit(){
  echo "Commiting changes: Adding cluster ${CLUSTER_NAME}"
  commit_changes "Remove utilities: ${CLUSTER_NAME}" $gitops_dir/${ENV}/helm-values
}

function wait_for_argocd() {
  echo "Waiting for argocd to sync"
  sleep 300
}

function remove_cluster() {
    local cluster_id=$1
    yq eval -i "del(.clusters[] | select(.name == \"${CLUSTER_NAME}\"))" $cluster_yaml
    stage_changes $cluster_yaml
    commit_changes "Removing cluster: ${CLUSTER_NAME}" $cluster_yaml
}

function main() {
  clone_repo
  remove_utilities
  remove_helm_values
  commit
  wait_for_argocd
  remove_cluster
  clean_up
}

main