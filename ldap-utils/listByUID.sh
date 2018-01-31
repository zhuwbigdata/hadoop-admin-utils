#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 <BaseDN in search> <UID>"
    exit 1
  fi
}

check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
eval ${LDAP_CMD} -b \'$1\' uid=\'$2\'
