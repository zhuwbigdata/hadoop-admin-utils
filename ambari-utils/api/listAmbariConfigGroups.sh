#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
curl  -u $AMBARI_ADMIN:$AMBARI_PASS -H "X-Requested-By: ambari" -i -X GET http://$AMBARI_SERVER:$AMBARI_PORT/api/v1/clusters/$AMBARI_CLUSTER/config_groups
