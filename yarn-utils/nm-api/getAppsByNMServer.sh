#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0 <node_manager_server>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
URL=http://${1}:${YARN_NM_PORT}/ws/v1/node/apps
#echo curl -X GET  $URL 
curl -X GET  $URL | python -mjson.tool
