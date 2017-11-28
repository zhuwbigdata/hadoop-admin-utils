#!/bin/bash
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <ENCRYTION_KEY_NAME> <ENCRYPTION_ZONE_PATH>"
    exit 1
  fi
}

check_usage $*
hdfs crypto -createZone -keyName $1 -path $2 
