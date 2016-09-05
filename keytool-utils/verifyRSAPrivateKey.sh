#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 SSL_PRIVATE_KEY_FILE"
    exit 1
  fi
}

check_usage $*
openssl rsa -check -in $1 
