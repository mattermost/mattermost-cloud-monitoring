#!/usr/bin/env bash

set -o errexit

function generate_token() {

  client_id=${GITHUB_APP_ID} # Client ID as first argument

  pem=$( cat ${GITHUB_APP_PEM_FILE} ) # file path of the private key as second argument

  now=$(date +%s)
  iat=$((${now} - 60)) # Issues 60 seconds in the past
  exp=$((${now} + 600)) # Expires 10 minutes in the future

  b64enc() { openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'; }

  header_json='{
      "typ":"JWT",
      "alg":"RS256"
  }'
  # Header encode
  header=$( echo -n "${header_json}" | b64enc )

  payload_json="{
      \"iat\":${iat},
      \"exp\":${exp},
      \"iss\":\"${client_id}\"
  }"
  # Payload encode
  payload=$( echo -n "${payload_json}" | b64enc )

  # Signature
  header_payload="${header}"."${payload}"
  signature=$(
      openssl dgst -sha256 -sign <(echo -n "${pem}") \
      <(echo -n "${header_payload}") | b64enc
  )

  # Create JWT
  JWT="${header_payload}"."${signature}"

  curl --silent --request POST \
    --url "https://api.github.com/app/installations/${GITHUB_APP_INSTALLATION_ID}/access_tokens" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: Bearer ${JWT}" \
    --header "X-GitHub-Api-Version: 2022-11-28" | jq .token --compact-output --raw-output
}


gitops_sre_dir="gitops-sre-${CLUSTER_NAME}"
gitops_apps_dir="$gitops_sre_dir/apps"
application_yaml="$gitops_apps_dir/${ENV}/application-values.yaml"
cluster_yaml="$gitops_sre_dir/clusters/${ENV}/cluster-values.yaml"

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
    echo "Cloning repo https://${GIT_REPO_URL}/${GIT_REPO_PATH}.git"
    if [[ -z "$GIT_REPO_URL" || -z "$GIT_REPO_PATH" ]]; then
        echo "GIT_REPO_URL and/or GIT_REPO_PATH  is empty"
        exit 1
    fi
    while_repo_exists
    GITHUB_TOKEN=$(generate_token)
    git clone "https://x-access-token:${GITHUB_TOKEN}@${GIT_REPO_URL}/${GIT_REPO_PATH}.git" $gitops_sre_dir

    current_dir=$(pwd)
    cd $gitops_sre_dir || exit
    git config user.name "${GIT_REPO_USERNAME}"
    git config user.email "${GIT_REPO_EMAIL}"
    cd $current_dir || exit
}

function create_new_branch() {
  branch_name=$1
  current_dir=$(pwd)

  cd $gitops_sre_dir || exit
  git checkout -b $branch_name
  cd $current_dir || exit
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

  else
    echo "No changes to commit"
  fi
}

function push_changes_to_git() {
  echo "Pushing changes to git"
  branch_name=$1
  current_dir=$(pwd)

  cd $gitops_sre_dir || exit
  git push origin $branch_name
  cd $current_dir || exit
}

function make_pr() {
  branch_name=$1
  pr_title="Deploy utilities for cluster ${CLUSTER_NAME}"
  pr_body="This PR adds/modify utilities for cluster ${CLUSTER_NAME}."

  current_dir=$(pwd)

  cd $gitops_sre_dir || exit
  GITHUB_TOKEN=$(generate_token)
  curl -L --silent --request POST \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: Bearer ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${GIT_REPO_PATH}/pulls" \
    --data "{
      \"title\": \"${pr_title}\",
      \"body\": \"${pr_body}\",
      \"head\": \"${branch_name}\",
      \"base\": \"main\"
    }"
  cd $current_dir || exit
}

function clean_up() {
    echo "Removing gitops-sre directory"
    rm -rf $gitops_sre_dir
    exit 0
}