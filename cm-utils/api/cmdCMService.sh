#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 <CMD: start, stop, restart>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
${CURL_CMD} -u "${CM_ADMIN}:${CM_PASS}" -i -X POST ${HTTP_PROTOCOL}://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/cm/service/commands/$1
