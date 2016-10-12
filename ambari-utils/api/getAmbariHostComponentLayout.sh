#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
curl -k -u $AMBARI_ADMIN:$AMBARI_PASS -H "X-Requested-By: ambari" -X GET https://localhost:$AMBARI_PORT/api/v1/clusters/$AMBARI_CLUSER/hosts?fields=host_components > ${AMBARI_CLUSER}_blueprint_$(date +"%F").json
