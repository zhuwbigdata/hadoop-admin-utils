#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 [KEY_STORE_LOC] [ALIAS]"
    exit 1
  fi
}

check_usage $*
JAVA_HOME=/usr/java/default
$JAVA_HOME/bin/keytool -keystore $1 -genkey -alias $2 
