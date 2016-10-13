#!/bin/bash
check_usage() {
  if [ $# -lt 4 ]
  then
    echo "Usage:"
    echo "$0 <hdfs_compressed_input_path> <hdfs_out_path> <compression_codec:BZip2|Gzip|Snappy|etc.> <exectype:mapreduce|spark|tez>"
    exit 1
  fi
}

check_usage $*
BASEDIR=$(dirname $0)
echo "compression codec=org.apache.hadoop.io.compress.${3}Codec"
/usr/bin/pig    -Dmapreduce.map.speculative=true \
	-Dmapreduce.reduce.speculative=true \
	-Dmapreduce.output.fileoutputformat.compress=false \
	-x ${4} \
	-param INPUT_DIR=$1 \
	-param OUTPUT_DIR=$2 \
	-file $BASEDIR/store.pig

exit 0

