#!/bin/bash

set -x

env

SERVER="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT"
TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`

URL="$SERVER/oapi/v1/namespaces/$NAMESPACE/routes/$JUPYTERHUB_SERVICE_NAME"

curl -s -k -H "Authorization: Bearer $TOKEN" $URL
