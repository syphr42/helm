#!/usr/bin/env bash
set -eo pipefail
shopt -s failglob

# Retrieve Redis password from secret
set +e
redis_password=$(kubectl --namespace "${K8S_NAMESPACE}" get secret "${K8S_SECRET_PASSWORDS}" -o go-template='{{index .data "redis-password" | base64decode}}' 2>/dev/null)
if [ "$?" != "0" ]; then
  echo_err "error: key 'redis-password' not found in secret ${K8S_SECRET_PASSWORDS} in namespace ${K8S_NAMESPACE}"
  exit 1
fi
set -e
