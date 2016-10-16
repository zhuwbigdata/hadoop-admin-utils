#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
#curl -i -X GET http://${YARN_SERVER}:${YARN_PORT}/ws/v1/cluster/info | python -mjson.tool
curl -X  GET http://${YARN_SERVER}:${YARN_PORT}/ws/v1/cluster/metrics  | python -mjson.tool
