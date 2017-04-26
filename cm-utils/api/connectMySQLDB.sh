#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 <USER> <PASSWORD>"
    exit 1
  fi
}

check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
mysql --host=$CM_DB_HOST --port=$CM_DB_PORT  --user=$1 --password=$2 
