#!/bin/bash
BASE_DIR=$(dirname $0)
dfs_dir=/user/$(whoami)/dfs
raw_input_dir=${dfs_dir}/input/raw/chicago
output_dir=${dfs_dir}/output/chicago/salarySumByDept
if  hdfs dfs -test -d ${output_dir} ; then
  hdfs dfs -rm -r -skipTrash ${output_dir}
fi
/usr/bin/pig	-Dmapreduce.map.speculative=true \
	-param INPUT_DIR=$raw_input_dir \
	-param OUTPUT_DIR=$output_dir \
	-file ${BASE_DIR}/salaryGroupByDept.pig

exit 0


