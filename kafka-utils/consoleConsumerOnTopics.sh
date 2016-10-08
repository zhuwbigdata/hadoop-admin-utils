#!/bin/bash
check_usage() {
  if [ $# -lt 1  ]
  then
    echo "Usage:"
    echo "$0  <topics>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
/usr/bin/kafka-console-consumer --zookeeper $ZK_QUORUM --topic $1 --from-beginning
