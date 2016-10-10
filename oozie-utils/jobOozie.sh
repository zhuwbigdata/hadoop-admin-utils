#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <OPTIONS>"
    /usr/bin/oozie help job 
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
/usr/bin/oozie job -oozie $OOZIE_URI $*
