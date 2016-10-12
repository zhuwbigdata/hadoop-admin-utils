#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <username> <password>"
    exit 1
  fi
}
beeline -u $SQOOP_JDBC_URL  -n $1 -p $2
