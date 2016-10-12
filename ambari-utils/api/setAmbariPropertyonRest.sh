#!/bin/bash
check_usage() {
  if [ $# -ne 3 ];
  then
    echo "Usage:"
    echo "$0 CONFIG_TYPE CONFIG_KEY CONFIG_VAL"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
CONFIG_TYPE=$1
CONFIG_KEY=$2
CONFIG_VAL=$3
$AMBARI_SCRIPTS_DIR/configs.sh -u $AMBARI_ADMIN -p $AMBARI_PASS -port $AMBARI_PORT -s set $AMBARI_SERVER $AMBARI_CLUSER $CONFIG_TYPE $CONFIG_KEY $CONFIG_VAL
