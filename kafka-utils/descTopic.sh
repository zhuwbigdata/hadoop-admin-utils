#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
/usr/bin/kafka-topics --zookeeper $ZK_QUORUM --describe $1
