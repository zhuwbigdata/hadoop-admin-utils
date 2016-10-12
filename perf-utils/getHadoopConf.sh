#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <hdfs_conf_key_file_path>"
    exit 1
  fi
}
check_usage $*

while IFS='' read -r line || [[ -n $line ]] ; do
   if [[  $line == \#* ]] || [[ -z $line ]]  ; then 
      echo $line
   else
      echo "$line: $(hdfs getconf -confkey $line)"
   fi
done < "$1"
