#!/bin/bash
uname=$(uname -n)
NN_MASTERS=$(uname -n)
MASTERS=$(uname -n)
SLAVES=$(uname -n)
BEELINE_JDBC_URL=jdbc:hive2://$(uname):10000/default
ZK_QUORUM=$(uname -n):2181
SPARK_HOME=/usr/lib/spark
KAFKA_BROKERS=$(uname -n):9092
export ALL_NODES=$(eval echo $MASTERS $SLAVES | tr ' ' \\n | sort | uniq | tr \\n ' ');
export MASTER_NODES=$(eval echo $MASTERS);
export SLAVE_NODES=$(eval echo $SLAVES);
export NN_MASTERS=$(eval echo $NN_MASTERS);
export BEELINE_JDBC_URL
export ZK_QUORUM
export SPARK_HOME 
export KAFKA_BROKERS
