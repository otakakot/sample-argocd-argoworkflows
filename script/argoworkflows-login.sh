#!/bin/bash -eu

export PORT=${1:-9191}

declare CONTEXT="kind-kind"

pod=$(kubectl --context ${CONTEXT} get pod -n argo --output json | jq -c '.items[]' | jq '.metadata.name' | grep 'server' | tr -d '"')

password=$(kubectl --context ${CONTEXT} exec -it -n argo "${pod}" -- argo auth token)
 
echo "${password}" | pbcopy

echo "Password: ${password}"

open http://localhost:${PORT}

kubectl --context ${CONTEXT} port-forward -n argo service/argo-workflows-server ${PORT}:2746
