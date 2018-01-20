#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <hql_file_path>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
if [ "$KRB_ENABLED" = true ]; then
  beeline -u $BEELINE_JDBC_URL --verbose=true --hiveconf hive.execution.engine=mr --hiveconf USER=$(whoami) --hiveconf mapreduce.queue.name=default --force=false --showWarnings=true --showNestedErrs=true -f $1 
else
  beeline -n $(whoami) -p $(cat mypass) -u $BEELINE_JDBC_URL --verbose=true --hiveconf hive.execution.engine=mr --hiveconf USER=$(whoami)  --hiveconf mapreduce.queue.name=default --force=false --showWarnings=true --showNestedErrs=true -f $1 
fi
