#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <FILE_INPUT>"
    echo "FILE FORMAT: path<tab>owner<tab>permission>"
    exit 1
  fi
}

check_usage $*
index=0
while IFS=$'\t' read -r -a myArray
do
 DIR_PATHS[$index]=${myArray[0]}
 DIR_UGS[$index]=${myArray[1]}
 DIR_PERMS[$index]=${myArray[2]}
 index=$(($index+1))
done < $1


#Read the array of tables and loop through them, performing code generation.
echo "Create HDFS directory $index"
i=0;
while [ $i -lt $index ]; do
 DIRPATH=${DIR_PATHS[$i]}
 DIRUG=${DIR_UGS[$i]}
 DIRPERM=${DIR_PERMS[$i]}
 echo "Create HDFS DIR: ${DIRPATH}  ${DIRUG} ${DIRPERM}"
 hdfs dfs -mkdir -p ${DIRPATH}
 hdfs dfs -chown -R ${DIRUG} ${DIRPATH}
 hdfs dfs -chmod -R ${DIRPERM} ${DIRPATH}
 i=$(($i+1))
done
echo "Done with creating directories."
