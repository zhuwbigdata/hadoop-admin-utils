#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
if [ "$KRB_ENABLED" = true ]; then
  beeline -u $BEELINE_JDBC_URL --color=true --hiveconf hive.execution.engine=mr --hiveconf tez.queue.name=default 
else
  beeline -n $(whddoami) -p $(cat mypass) -u $BEELINE_JDBC_URL --color=true --hiveconf hive.execution.engine=mr --hiveconf tez.queue.name=default 
fi
