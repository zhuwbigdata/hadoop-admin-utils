#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
${CURL_CMD} -u "${CM_ADMIN}:${CM_PASS}" -i -X POST ${HTTP_PROTOCOL}://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/cm/commands/inspectHosts
