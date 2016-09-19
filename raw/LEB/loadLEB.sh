#!/bin/bash
BASE_DIR=$(dirname $0)
dfs_dir=/user/$(whoami)/dfs
raw_input_dir=${dfs_dir}/input/raw/plaintextdos
input_file=$BASE_DIR/LEB.txt
if  hdfs dfs -test -d $raw_input_dir ; then
  hdfs dfs -rm -r -skipTrash $raw_input_dir
fi
hdfs dfs -mkdir -p $raw_input_dir 
hdfs dfs -put $input_file $raw_input_dir 
hdfs dfs -ls -R $dfs_dir 
