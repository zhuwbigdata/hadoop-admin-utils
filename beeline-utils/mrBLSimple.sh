#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
beeline -n $(whoami) -p $(whoami) -u "'$BEELINE_JDBC_URL'" --color=true --hiveconf hive.execution.engine=mr --hiveconf tez.queue.name=default 
