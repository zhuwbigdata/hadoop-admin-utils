#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <user_group_definition_input_file>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
index=0
while  IFS=$'\t' read -r -a myArray ;
do
 users[$index]=${myArray[0]}
 groups[$index]=${myArray[1]}
 index=$(($index+1))
done < ${1}
i=0
while [ ${i} -lt ${index} ]; do
  user=${users[${i}]}
  group=${groups[${i}]}
  echo $user  " " $group
  sudo useradd -G $group  $user
  #for j in ${ALL_NODES}; do
  #   ssh -n ${j} "sudo /usr/sbin/useradd -g $group -m $user";
  #done
  i=$((${i}+1))
done		 

 
