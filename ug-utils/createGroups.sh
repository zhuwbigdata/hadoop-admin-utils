#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <group_definition_input_file>"
    exit 1
  fi
}
check_usage $*
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
for line in $(cat $1); do
	group=$line
 	for i in ${ALL_NODES}; do
		ssh -n ${i} "sudo /usr/sbin/groupadd $group";
	done
done
