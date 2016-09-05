#!/bin/bash
check_usage() {
  if [ $# -lt 3 ];
  then
    echo "Usage:"
    echo "$0 [ALIAS] [CA_FILE_LOC] [KEYSTORE_LOC]"
    exit 1
  fi
}

check_usage $*
JAVA_HOME=/usr/java/default
$JAVA_HOME/bin/keytool -importcert -file $2  -alias $1 -keystore $3 
