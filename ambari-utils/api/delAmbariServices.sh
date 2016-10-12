#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <FQHN>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
echo curl -k -u $AMBARI_ADMIN:$AMBARI_PASS -H \"X-Requested-By: ambarii\" -X DELETE https://localhost:$AMBARI_PORT/api/v1/clusters/${AMBARI_CLUSER}/services/${1}
