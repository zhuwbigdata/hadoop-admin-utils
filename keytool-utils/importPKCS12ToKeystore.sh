#!/bin/bash
check_usage() {
  if [ $# -lt 4 ];
  then
    echo "Usage:"
    echo "$0 [PKCS12_INPUT_FILE] [JKS_OUTPUT_FILE] [INPUT_ALIAS] [OUT_ALIAS]"
    exit 1
  fi
}

check_usage $*
keytool -importkeystore -srckeystore $1 -srcstoretype PKCS12 -destkeystore $2 -deststoretype JKS -srcalias $3 -destalias $4 
