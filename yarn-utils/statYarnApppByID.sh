#!/bin/bash	
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 <AppID>"
    exit 1
  fi
}

check_usage $*
yarn application -status $1
