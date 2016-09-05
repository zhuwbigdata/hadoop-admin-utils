#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <scala_file_path>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
cat $1 | $SPARK_HOME/bin/spark-shell; stty echo
