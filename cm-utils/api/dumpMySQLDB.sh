#!/bin/bash
check_usage() {
  if [ $# -lt 3 ];
  then
    echo "Usage:"
    echo "$0 <USER> <PASSWORD> <DBNAME>"
    exit 1
  fi
}

check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
echo "mysqldump --host=$CM_DB_HOST --port=$CM_DB_PORT  --user=$1 --password=$2 $3 > /tmp/${3}-backup.sql"
