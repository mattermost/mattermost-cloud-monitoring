#/usr/bin/env bash

gitops_dir="gitops-sre/apps"
application_yaml="$gitops_dir/${ENV}/application-values.yaml"

function escape_string() {
    local input="$1"
    local escaped=$(printf '%s' "$input" | sed 's/[\/&]/\\&/g; s/-/\\-/g')
    echo "$escaped"
}

function stage_changes() {
  echo "Staging changes"
  file_path=$1

  repo_path=$(dirname $file_path)
  file_name=$(basename $file_path)
  current_dir=$(pwd)

  cd $repo_path || exit
  git add "$file_name"
  cd $current_dir || exit
}

function commit_changes() {
  if [ -n "$(git -C gitops-sre status --porcelain)" ]; then
    echo "Commiting changes"
    commit_message=$1
    file_path=$2

    repo_path=$(dirname $file_path)
    current_dir=$(pwd)

    cd $repo_path || exit
    git commit -m "$commit_message"

    cd $current_dir || exit

    push_changes_to_git
  else
    echo "No changes to commit"
  fi
}

function push_changes_to_git() {
  echo "Pushing changes to git"
  current_dir=$(pwd)

  cd gitops-sre || exit
  git push origin main
  cd $current_dir || exit
}

function clean_up() {
    echo "Removing gitops-sre directory"
    rm -rf "gitops-sre"
    echo "Removing kubeconfig"
    rm -rf "kubeconfig"
    exit 0
}

function get_load_balancer_endpoint() {
    namespace = $1
    endpoint=$(KUBECONFIG=$KUBECONFIG kubectl -n $namespace get svc -o json | jq -r '.items[] | select(.spec.type=="LoadBalancer").status.loadBalancer.ingress[].hostname')
    if [ -z "$endpoint" ]; then
        echo "LoadBalancer endpoint is empty"
        exit 1
    fi
    echo $endpoint
}
