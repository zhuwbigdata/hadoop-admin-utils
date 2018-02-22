#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 <SERVICE_NAME> <COMPONENT_NAME>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
curl  -u $AMBARI_ADMIN:$AMBARI_PASS -H "X-Requested-By: ambari" -i -X GET http://$AMBARI_SERVER:$AMBARI_PORT/api/v1/clusters/${AMBARI_CLUSTER}/services/$1/components/$2
