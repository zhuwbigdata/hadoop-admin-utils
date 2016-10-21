#!/bin/bash
check_usage() {
  if [ $# -lt 3 ];
  then
    echo "Usage:"
    echo "$0 <SERVICE_NAME> <ROLE_CONFIG_GROUP_NAME> <RCG_CONFIG_FILE>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
URL=http://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/clusters/${CM_CLUSTER}/services/$1/roleConfigGroups/$2/config 
CONF=\'$(cat $3)\'
eval curl -X PUT -u "${CM_ADMIN}:${CM_PASS}" -H \"content-type:application/json\" \
-d $CONF $URL
