#!/bin/bash
check_usage() {
  if [ $# -lt 4 ];
  then
    echo "Usage:"
    echo "$0 [PEM_CERT_INPUT_FILE] [PEM_PRIVATE_KEY_INPUT_FILE] [ALIAS] [PKCS12_OUTPUT_FILE]"
    exit 1
  fi
}

check_usage $*
openssl pkcs12 -export -in $1 -inkey $2 -name $3 -out $4
