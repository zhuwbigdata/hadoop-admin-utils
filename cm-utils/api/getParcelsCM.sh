#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
curl -u "${CM_ADMIN}:${CM_PASS}" -i -X GET http://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/clusters/${CM_CLUSTER}/parcels
