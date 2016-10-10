#!/bin/bash
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0 <NN_URI> <RM_URI>"
    exit 1
  fi
}
check_usage $*
find examples/apps/*/ -name job.properties  | xargs sed -i -e "s/localhost:8020/${1}/g"
find examples/apps/*/ -name job.properties  | xargs sed -i -e "s/localhost:8021/${2}/g"
