#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  <>"
    exit 1
  fi
}
check_usage $*
yum --disablerepo="*" --enablerepo="$1" list available
