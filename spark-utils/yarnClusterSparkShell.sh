#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
$SPARK_HOME/bin/spark-shell --master yarn --deploy-mode cluster
