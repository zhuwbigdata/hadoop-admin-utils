#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
#$SPARK_HOME/bin/spark-shell --master yarn-client --driver-memory 512m --executor-memory 2024m
$SPARK_HOME/bin/spark-shell --master yarn --deploy-mode client 
