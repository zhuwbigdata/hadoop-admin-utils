#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 SSL_CERTIFICATE_FILE"
    exit 1
  fi
}

check_usage $*
openssl s_client -connect $1 
