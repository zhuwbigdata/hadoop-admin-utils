#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <sql_file_path>"
    exit 1
  fi
}
check_usage $*
/usr/bin/impala-shell -i $IMPALA_URI -f $1 --quiet
