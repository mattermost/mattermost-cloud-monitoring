#/usr/bin/env bash

set -e -x

source $(dirname "$0")/utils.sh

#TODO
# function remove_cluster() {
#     local cluster_id=$1
#     yq eval "del(.clusters[] | select(.labels.\"cluster-id\" == \"${cluster_id}\"))" -i $cluster_yaml
# }
