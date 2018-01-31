#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <username>"
    exit 1
  fi
}
sqoop list-tables --connect $SQOOP_JDBC_URL --username $1 -P 
