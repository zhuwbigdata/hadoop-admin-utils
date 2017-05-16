#!/bin/bash
uname=$(uname -n)
NN_MASTERS=$(uname -n)
MASTERS=$(uname -n)
SLAVES=$(uname -n)
KAFKA_BROKERS=$(uname -n):9092
OOZIE_URI=http://$(uname -n):11000/oozie 
SQOOP_JDBC_URL="jdbc:oracle:thin:@//$(uname -n):1521/xe"
YARN_URI=$(uname -n):8088
export ALL_NODES=$(eval echo $MASTERS $SLAVES | tr ' ' \\n | sort | uniq | tr \\n ' ');
export MASTER_NODES=$(eval echo $MASTERS);
export SLAVE_NODES=$(eval echo $SLAVES);
export NN_MASTERS=$(eval echo $NN_MASTERS);
export ZK_QUORUM=prodnj-lnx-hdpwkr01.mio.local:2181,prodnj-lnx-hdpwkr02.mio.local:2181,prodnj-lnx-hdpwkr03.mio.local:2181
export SPARK_HOME=/opt/cloudera/parcels/CDH-5.11.0-1.cdh5.11.0.p0.34/lib/spark
export KAFKA_BROKERS
export IMPALA_URI=prodnj-lnx-hdpedge01.mio.local:21050
export OOZIE_URI
export SQOOP_JDBC_URL
export KRB_ENABLED=true
if [ "$KRB_ENABLED" = true ]; then
  export BEELINE_JDBC_URL='jdbc:hive2://prodnj-lnx-hdpmstr01.mio.local:10000/default;principal=hive/prodnj-lnx-hdpmstr01.mio.local@MIO.LOCAL'
else
  export BEELINE_JDBC_URL='jdbc:hive2://prodnj-lnx-hdpmstr01.mio.local:10000/default'
fi
