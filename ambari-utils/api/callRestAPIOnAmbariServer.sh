#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
echo $AMBARI_SCRIPTS_DIR/configs.sh -u admin -p $(cat admin.pass) -port $AMBARI_PORT -s  $ACTION $AMBARI_SERVER $AMBARI_CLUSER  
