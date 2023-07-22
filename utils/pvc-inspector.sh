#!/usr/bin/env bash
set -eo pipefail
shopt -s failglob

if [ -z "${1}" ]; then
  echo "error: no pvc name given"
  exit 1
fi
inspector_pvc_name=${1}

kubectl run pvc-inspector --rm -it --restart Never --image alpine --overrides="
{
  \"apiVersion\": \"v1\",
  \"spec\": {
    \"containers\": [
      {
        \"name\": \"pvc-inspector\",
        \"image\": \"alpine\",
        \"command\": [
          \"ash\"
        ],
        \"volumeMounts\": [
          {
            \"name\": \"data\",
            \"mountPath\": \"/data\"
          }
        ],
        \"stdin\": true,
        \"tty\": true
      }
    ],
    \"volumes\": [
      {
        \"name\": \"data\",
        \"persistentVolumeClaim\": {
          \"claimName\": \"${inspector_pvc_name}\"
        }
      }
    ]
  }
}"
