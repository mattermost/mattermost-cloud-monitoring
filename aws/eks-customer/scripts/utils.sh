#/usr/bin/env bash

gitops_sre_dir="gitops-sre-${CLUSTER_NAME}"
gitops_apps_dir="$gitops_sre_dir/apps"
application_yaml="$gitops_apps_dir/${ENV}/application-values.yaml"
cluster_yaml="$gitops_sre_dir/clusters/${ENV}/cluster-values.yaml"

function escape_string() {
    local input="$1"
    local escaped=$(printf '%s' "$input" | sed 's/[\/&]/\\&/g; s/-/\\-/g')
    echo "$escaped"
}

function clone_repo() {
    echo "Cloning repo $GIT_REPO_URL"
    if [ -z "$GIT_REPO_URL" ]; then
        echo "Git URL is empty"
        exit 1
    fi
    while_repo_exists
    git clone $GIT_REPO_URL $gitops_sre_dir
}

function while_repo_exists() { #This is to avoid github race condition errors when we have multiple clusters.
    while ls -d "gitops-sre-*" 1> /dev/null 2>&1; do
        echo "Waiting for gitops-sre dir to be removed"
        sleep 5
    done
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
  if [ -n "$(git -C $gitops_sre_dir status --porcelain)" ]; then
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

  cd $gitops_sre_dir || exit
  git push origin main
  cd $current_dir || exit
}

function clean_up() {
    echo "Removing gitops-sre directory"
    rm -rf $gitops_sre_dir
    exit 0
}