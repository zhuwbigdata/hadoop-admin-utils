#!/bin/bash
check_usage() {
  if [ $# -lt 3 ];
  then
    echo "Usage:"
    echo "$0 JCEKS_ALIAS PASSWORD JCEKS_LOC"
    exit 1
  fi
}
check_usage $*
/usr/java/default/bin/java -cp "/usr/hdp/current/ranger-hdfs-plugin/install/lib/*" com.hortonworks.credentialapi.buildks create $1 -value $2 -provider jceks://file${3}
