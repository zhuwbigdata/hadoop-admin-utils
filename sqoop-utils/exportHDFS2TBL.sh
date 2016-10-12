#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
check_usage() {
  if [ $# -lt 3 ]
  then
    echo "Usage:"
    echo "$0  <username> <export_dir> <table_name>""
    exit 1
  fi
}
check_usage $*
sqoop export --connect $SQOOP_JDBC_URL --username $1 -P --export-dir $2 --table $3 
