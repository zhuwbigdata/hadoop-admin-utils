#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 <CLUSTER_NAME>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
${CURL_CMD} -u "${CM_ADMIN}:${CM_PASS}" -i -X GET ${HTTP_PROTOCOL}://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/clusters/$1/parcels/usage
