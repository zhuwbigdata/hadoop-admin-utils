#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
curl -k -u $AMBARI_ADMIN:$AMBARI_PASS -H "X-Requested-By: ambari" -i -X GET http://localhost:$AMBARI_PORT/api/v1/clusters
