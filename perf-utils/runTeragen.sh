#!/bin/bash
MR_EXAMPLE_JAR_LOC=/usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <number_of_rows_with_100-bytes> <output_dir>"
    hadoop jar $MR_EXAMPLE_JAR_LOC teragen
    exit 1
  fi
}
check_usage $*
DFS_BLOCK_SZ=$(hdfs getconf -confKey dfs.blocksize) 
echo "HDFS BLOCK SIZE:$DFS_BLOCK_SZ"
if  hdfs dfs -test -d $2 ; then
  hdfs dfs -rm -r -skipTrash $2
fi
hadoop jar $MR_EXAMPLE_JAR_LOC teragen $1 $2
