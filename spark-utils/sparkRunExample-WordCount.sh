#!/bin/bash
check_usage() {
  if [ $# -lt 3 ]
  then
    echo "Usage:"
    echo "$0  <group> <topics> <numThreads>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
$SPARK_HOME/bin/run-example streaming.KafkaWordCount $ZK_QUORUM $1 $2 $3 
