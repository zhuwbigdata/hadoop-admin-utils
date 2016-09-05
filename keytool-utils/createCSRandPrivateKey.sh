#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 HOST_NAME"
    exit 1
  fi
}

check_usage $*
openssl req -sha256 -new -newkey rsa:2048 -nodes -keyout ${1}.key -out ${1}.csr 
