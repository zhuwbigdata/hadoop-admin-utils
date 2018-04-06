#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
${CURL_CMD}  "${HTTP_PROTOCOL}://${HBASE_RESTSVR_HOST}:${HBASE_RESTSVR_PORT}/version/cluster"
