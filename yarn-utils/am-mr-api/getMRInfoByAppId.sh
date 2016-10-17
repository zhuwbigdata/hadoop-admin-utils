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
URL=http://${YARN_PROXY_SERVER}:${YARN_PROXY_PORT}/proxy/${1}/ws/v1/mapreduce/info 
#echo curl -X GET  $URL 
curl -L -X GET  $URL | python -mjson.tool
