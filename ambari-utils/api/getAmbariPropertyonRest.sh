#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 CONFIG_TYPE <CONFIG_KEY>"
    exit 1
  fi
}

check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
CONFIG_TYPE=$1
CONFIG_KEY=$2
if [ -z $CONFIG_KEY ];
then
  $AMBARI_SCRIPTS_DIR/configs.sh -u $AMBARI_ADMIN -p $AMBARI_PASS -port $AMBARI_PORT -s get $AMBARI_SERVER $AMBARI_CLUSER $CONFIG_TYPE
else
  $AMBARI_SCRIPTS_DIR/configs.sh -u $AMBARI_ADMIN -p $AMBARI_PASS -port $AMBARI_PORT -s get $AMBARI_SERVER $AMBARI_CLUSER $CONFIG_TYPE | grep -i $CONFIG_KEY
fi
