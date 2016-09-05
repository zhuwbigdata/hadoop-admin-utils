#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <py_file_path>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
$SPARK_HOME/bin/spark-submit $1
