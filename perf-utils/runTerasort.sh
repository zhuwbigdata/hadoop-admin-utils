#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
MR_EXAMPLE_JAR_LOC=/usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <input_dir> <output_dir>"
    exit 1
  fi
}
check_usage $*
echo "HDFS BLOCK SIZE:$DFS_BLOCK_SZ"
if  hdfs dfs -test -d $2 ; then
  hdfs dfs -rm -r -skipTrash $2
fi
hadoop jar $MR_EXAMPLE_JAR_LOC terasort $1 $2
