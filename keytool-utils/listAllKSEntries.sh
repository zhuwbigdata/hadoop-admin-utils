#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 $KEY_STORE_LOC"
    exit 1
  fi
}

check_usage $*
JAVA_HOME=/usr/java/default
$JAVA_HOME/bin/keytool -list -v -keystore $1
