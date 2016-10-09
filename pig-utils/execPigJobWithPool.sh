#!/bin/bash
if [ $# -ne 2 ] ; then
echo "USAGE: $0 [JobName] [POOL_NAME]"
exit 1
fi

START_TIME=`date +%s`
START_TIME1=`date`
now=$(date +"%Y-%m-%d-%M-%S")
JOB_NAME=$1
POOL_NAME=$2
SERVER=$(hostname)
PWD=$(pwd)
LOG_DIR=$JOB_LOG_DIR
LOG_FILE=$JOB_LOG_DIR/$JOB_NAME.$now.log
BASEDIR=$(dirname $0)
PIG_DIR=$BASEDIR/../scripts/pig
PIG_FILE=$PIG_DIR/${JOB_NAME}.pig
CONFIG_DIR=$BASEDIR/../config
CONFIG_FILE=$CONFIG_DIR/${JOB_NAME}.config

echo "JOB_NAME=$JOB_NAME" 	>> $LOG_FILE
echo "LOG_FILE=$LOG_FILE" 	>> $LOG_FILE
echo "BASEDIR=$BASEDIR"   	>> $LOG_FILE
echo "PIG_FILE=$PIG_FILE" 	>> $LOG_FILE
echo "CONFIG_FILE=$CONFIG_FILE" >> $LOG_FILE

/usr/bin/pig -useHCatalog \
    -Dpool.name=$POOL_NAME \
    -Dmapred.map.tasks.speculative.execution=true \
    -Dmapred.reduce.tasks.speculative.execution=true \
    -Dmapred.min.split.size=536870912 \
    -Dmapred.max.split.size=536870912 \
    -Dmapred.input.compress=true \
    -Dmapred.input.compression.codec="org.apache.hadoop.io.compress.BZip2Codec" \
    -Dmapred.output.compress=true \
    -Dmapred.output.compression.codec="org.apache.hadoop.io.compress.BZip2Codec" \
    -param_file  $CONFIG_FILE \
    $PIG_FILE  >> $LOG_FILE 2>&1
rc=$?

ERRORMSG=$(cat $LOG_FILE | grep -i ERROR)
if [ $rc -ne 0 ];
then
   echo $ERRORMSG
   exit 2;
fi
exit 0;
