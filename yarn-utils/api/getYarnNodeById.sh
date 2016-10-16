#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0 <node_id>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
URL=http://${YARN_SERVER}:${YARN_PORT}/ws/v1/cluster/nodes/${1} 
#echo curl -X GET  $URL 
curl -X GET  $URL | python -mjson.tool
