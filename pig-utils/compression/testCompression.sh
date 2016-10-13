#!/bin/bash
#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <exectype=mapreduce,tez,spark>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
dfs_dir=/user/$(whoami)/dfs
raw_input_dir=${dfs_dir}/input/raw/chicago
output_dir=${dfs_dir}/output/compressed
bzip2_output_dir=${dfs_dir}/output/compressed/bzip2
gzip_output_dir=${dfs_dir}/output/compressed/gzip
snappy_output_dir=${dfs_dir}/output/compressed/snappy
deflate_output_dir=${dfs_dir}/output/compressed/deflate
if  hdfs dfs -test -d $bzip2_output_dir ; then
  hdfs dfs -rm -r -skipTrash $bzip2_output_dir
fi
if  hdfs dfs -test -d $gzip_output_dir ; then
  hdfs dfs -rm -r -skipTrash $gzip_output_dir
fi
if  hdfs dfs -test -d $snappy_output_dir ; then
  hdfs dfs -rm -r -skipTrash $snappy_output_dir
fi
if  hdfs dfs -test -d $deflate_output_dir ; then
  hdfs dfs -rm -r -skipTrash $deflate_output_dir
fi
echo "Compressing with BZip2 ..."
$BASE_DIR/compressWithPig.sh $raw_input_dir $bzip2_output_dir  BZip2 $1 
echo "Compressing with GZip ..."
$BASE_DIR/compressWithPig.sh $raw_input_dir $gzip_output_dir   Gzip $1 
echo "Compressing with Snappy ..."
$BASE_DIR/compressWithPig.sh $raw_input_dir $snappy_output_dir Snappy $1 
echo "Compressing with Deflate ..."
$BASE_DIR/compressWithPig.sh $raw_input_dir $deflate_output_dir Default $1 
