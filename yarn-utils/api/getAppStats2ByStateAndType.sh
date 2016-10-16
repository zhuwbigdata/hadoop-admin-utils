#!/bin/bash
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0 <State:NEW, NEW_SAVING, SUBMITTED, ACCEPTED, RUNNING, FINISHED, FAILED, KILLED> <Type:mapreduce|spark|tez>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
#curl -i -X GET http://${YARN_SERVER}:${YARN_PORT}/ws/v1/cluster/info | python -mjson.tool
URL=http://${YARN_SERVER}:${YARN_PORT}/ws/v1/cluster/appstatistics?states=${1}\&applicationTypes=${2} 
#echo curl -X GET  $URL 
curl -X GET  $URL | python -mjson.tool
