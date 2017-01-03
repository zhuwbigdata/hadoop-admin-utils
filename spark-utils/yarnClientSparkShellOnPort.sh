#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <spark.yarn.am.port>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
#source $BASE_DIR/../bin/setenv.sh
/bin/spark-shell --master yarn --deploy-mode client  --driver-java-options=-Dspark.yarn.am.port=$1
