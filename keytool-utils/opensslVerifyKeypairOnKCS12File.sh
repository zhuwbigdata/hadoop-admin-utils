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
openssl pkcs12 -info -in $1 
