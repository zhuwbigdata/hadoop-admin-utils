#!/bin/bash	
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 <UID>"
    exit 1
  fi
}

check_usage $*
yarn rmadmin -getGroups $1 
