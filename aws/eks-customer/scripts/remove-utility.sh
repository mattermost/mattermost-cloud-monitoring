#/usr/bin/env bash

set -e -x

# source $(dirname "$0")/utils.sh

echo "REMOVE UTILITY FROM GITOPS REPO"
echo $GIT_REPO_URL
echo $CLUSTER_NAME
echo $ENV
echo $1
#TODO
# function remove_cluster() {
#     local cluster_id=$1
#     yq eval "del(.clusters[] | select(.labels.\"cluster-id\" == \"${cluster_id}\"))" -i $cluster_yaml
# }
sleep 120