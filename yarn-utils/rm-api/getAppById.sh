#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0 <app_id>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
URL=http://${YARN_RM_SERVER}:${YARN_RM_PORT}/ws/v1/cluster/apps/${1} 
#echo curl -X GET  $URL 
curl -X GET  $URL | python -mjson.tool
