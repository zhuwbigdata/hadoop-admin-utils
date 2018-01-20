#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <ENCRYTION_KEY_NAME>"
    exit 1
  fi
}

check_usage $*
hadoop key create $1
