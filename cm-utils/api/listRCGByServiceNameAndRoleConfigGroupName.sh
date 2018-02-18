#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 <SERVICE_NAME> <ROLE_CONFIG_GROUP_NAME>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
echo ${CURL_CMD} -u "${CM_ADMIN}:${CM_PASS}" -i -X GET ${HTTP_PROTOCOL}://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/clusters/${CM_CLUSTER}/services/$1/roleConfigGroups/$2?view=full
