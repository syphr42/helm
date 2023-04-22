#!/bin/bash
set -eo pipefail
shopt -s failglob

cat << EOF |
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: dns-test
  name: dns-test
  namespace: mariadb
spec:
  containers:
  - image: debian:buster-slim
    name: dns-test
    command: [ 'sh', '-c', 'while true; do sleep 5s; done' ]
    resources: {}
  restartPolicy: Never
  dnsConfig:
    searches:
      - cluster.local
    options:
      - name: ndots
        value: "1"
EOF
kubectl apply -f -

#  dnsPolicy: ClusterFirst
