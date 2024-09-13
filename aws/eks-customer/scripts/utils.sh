#/usr/bin/env bash

gitops_sre_dir="gitops-sre-${CLUSTER_NAME}"
gitops_apps_dir="$gitops_sre_dir/apps"
application_yaml="$gitops_apps_dir/${ENV}/application-values.yaml"
cluster_yaml="$gitops_sre_dir/clusters/${ENV}/cluster-values.yaml"

# Add ssh key to known hosts
mkdir ~/.ssh || true
ssh-keyscan -T 240 $GIT_HOST >> ~/.ssh/known_hosts

function escape_string() {
    local input="$1"
    local escaped=$(printf '%s' "$input" | sed 's/[\/&]/\\&/g; s/-/\\-/g')
    echo "$escaped"
}

function while_repo_exists() { #This is to avoid github race condition errors when we have multiple clusters.
    while true; do
      if ls "." | grep -E "gitops-sre-.*"; then
          echo "Directory matching the pattern exists."
          sleep 3
      else
          echo "No matching directory found. Retrying..."
          break
      fi
    done
}

function clone_repo() {
    sleep $((5 + RANDOM % 50)) # Random sleep
    echo "Cloning repo https://${GIT_HOST}/${GIT_REPO_PATH}"
    if [ -z "$GIT_HOST" || -z "$GIT_REPO_PATH" ]; then
        echo "GIT_HOST and/or GIT_REPO_PATH  is empty"
        exit 1
    fi
    while_repo_exists
    git clone "https://${GIT_REPO_USERNAME}:${GITLAB_OAUTH_TOKEN}@${GIT_HOST}/${GIT_REPO_PATH}" $gitops_sre_dir
    git config --global user.name "${GIT_REPO_USERNAME}"
    git config --global user.email "${GIT_REPO_USERNAME}@mattermost.com"
}

function stage_changes() {
  echo "Staging changes"

  file_path=$1

  repo_path=$(dirname $file_path)
  file_name=$(basename $file_path)
  current_dir=$(pwd)

  cd $repo_path || exit
  echo "Pulling latest changes"
  git pull origin main
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
