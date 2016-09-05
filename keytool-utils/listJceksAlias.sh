#!/bin/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 JCEKS_LOC"
    exit 1
  fi
}
check_usage $*
/usr/java/default/bin/java -cp "/usr/hdp/current/ranger-hdfs-plugin/install/lib/*" com.hortonworks.credentialapi.buildks list -provider jceks://file${1}
