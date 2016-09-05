#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 [DER_CERT_INPUT_FILE] [PEM_CERT_INPUT_FILE]"
    exit 1
  fi
}

check_usage $*
openssl x509 -in $1 -inform der -out $2 -outform pem
