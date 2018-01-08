#!/bin/bash
if [ $# -ne 2 ] ; then
echo "USAGE: $0 [days] [HDFF_DIRi_PATH]"
exit 1
fi
days=$1
hdfs_path=$2
now=$(date +%s)
hdfs dfs  -ls -R $hdfs_path | grep --invert-match "^d" | while read f; do
 dir_yyyymmdd=`echo $f | awk '{print $6}'`
 dir_hhmm=`echo $f | awk '{print $7}'`
 dir_path=`echo $f | awk '{print $8}'`
 difference=$(( ( $now - $(date -d "$dir_yyyymmdd $dir_hhmm" +%s) ) / (24 * 60 * 60 ) ))
 if [ $difference -le $days ]; then
   echo $dir_path;
 fi
done

