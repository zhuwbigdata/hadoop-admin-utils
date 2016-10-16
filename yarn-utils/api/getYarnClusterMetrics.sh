#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
URL=http://${YARN_SERVER}:${YARN_PORT}/ws/v1/cluster/metrics
curl -X  GET $URL  | python -mjson.tool
