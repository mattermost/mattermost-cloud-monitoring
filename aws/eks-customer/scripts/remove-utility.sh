#!/usr/bin/env bash

set -o errexit

source $(dirname "$0")/utils.sh

echo "REMOVE UTILITY FROM GITOPS REPO"

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
  remove_utilities
  remove_helm_values
  wait_for_argocd
  remove_cluster
  clean_up
}

main
