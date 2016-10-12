#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <username> <query>""
    exit 1
  fi
}
check_usage $*
echo sqoop eval --connect $SQOOP_JDBC_URL --username $1 -P --query \"${2}\" 
