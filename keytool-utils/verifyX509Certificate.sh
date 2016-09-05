#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 CERT_FORMAT[PEM|DER|NET] SSL_CERTIFICATE_FILE"
    exit 1
  fi
}

check_usage $*
openssl x509 -text -noout -inform $1 -in $2   
