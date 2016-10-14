#!/bin/bash
check_usage() {
  if [ $# -lt 3 ];
  then
    echo "Usage:"
    echo "$0 <SERVICE_NAME> <ROLE_NAME> <CONFIG_FILE_NAME>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
curl -u "${CM_ADMIN}:${CM_PASS}" -i -X GET http://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/clusters/${CM_CLUSTER}/services/$1/roles/$2/process/configFiles/$3
