#!/bin/bash
check_usage() {
  if [ $# -lt 3 ]
  then
    echo "Usage:"
    echo "$0 <hdfs_input_path> <hdfs_compressed_out_path> <compression_codec:BZip2|Gzip|Snappy|etc.> <execType:mapreduce|spark|tez>"
    exit 1
  fi
}

check_usage $*
BASEDIR=$(dirname $0)
echo "compression codec=org.apache.hadoop.io.compress.${3}Codec"
/usr/bin/pig	-Dmapreduce.map.speculative=true \
	-Dmapreduce.input.fileinputformat.split.minsize=2147483648 \
	-Dmapreduce.input.fileinputformat.split.maxsize=2147483648 \
	-Dmapreduce.output.fileoutputformat.compress=true \
	-Dmapreduce.map.output.compression.codec="org.apache.hadoop.io.compress.${3}Codec" \
	-Dmapreduce.output.compression.codec="org.apache.hadoop.io.compress.${3}Codec" \
	-Dmapreduce.reduce.speculative=true \
	-exectype ${4} \
	-param INPUT_DIR=$1 \
	-param OUTPUT_DIR=$2 \
	-file $BASEDIR/store.pig

exit 0


