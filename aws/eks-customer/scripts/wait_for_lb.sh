#!/usr/bin/env bash

set -o errexit

NAMESPACE=${NAMESPACE}
SERVICE_NAME=${SERVICE_NAME}
TIMEOUT=${TIMEOUT:-300}
INTERVAL=${INTERVAL:-5}

echo "Waiting for LoadBalancer service '$SERVICE_NAME' in namespace '$NAMESPACE' to be ready (timeout: $TIMEOUT seconds)..."

SECONDS=0
while [[ $SECONDS -lt $TIMEOUT ]]; do
    HOSTNAME=$(kubectl -n "$NAMESPACE" get svc "$SERVICE_NAME" -o json | jq -r '.status.loadBalancer.ingress[0].hostname // empty')

    if [[ -n "$HOSTNAME" ]]; then
        echo "LoadBalancer is ready: $HOSTNAME"
        exit 0
    fi

    echo "Waiting for LoadBalancer hostname..."
    sleep $INTERVAL
done

echo "Timeout reached! LoadBalancer service did not become ready."
exit 1
