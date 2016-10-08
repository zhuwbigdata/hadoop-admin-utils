#!/bin/bash
check_usage() {
  if [ $# -lt 3  ]
  then
    echo "Usage:"
    echo "$0  <topic> <partition_number> <replication_factor>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
/usr/bin/kafka-topics --zookeeper $ZK_QUORUM --create --topic $1 --partitions $2 --replication-factor $3 
