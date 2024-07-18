#/usr/bin/env bash

function clone_repo() {
    echo "Cloning repo $GIT_REPO_URL"
    if [ -z "$GIT_REPO_URL" ]; then
        echo "Git URL is empty"
        exit 1
    fi
    if [ -d "gitops-sre" ]; then
        echo "Directory gitops-sre already exists"
    else
        git clone $GIT_REPO_URL gitops-sre
    fi
}

clone_repo