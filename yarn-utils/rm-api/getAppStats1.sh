#!/bin/bash
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
URL=http://${YARN_RM_SERVER}:${YARN_RM_PORT}/ws/v1/cluster/appstatistics
curl -X GET  $URL | python -mjson.tool
