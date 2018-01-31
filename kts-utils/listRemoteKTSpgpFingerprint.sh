#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 <KTS_FQHN>"
    exit 1
  fi
}

check_usage $*
curl -kv https://$1:11371/?a=fingerprint
