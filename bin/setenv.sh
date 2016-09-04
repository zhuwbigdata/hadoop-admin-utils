#!/bin/bash
uname=$(uname -n)
NN_MASTERS=${uname}
MASTERS=${uname}
SLAVES=${uname}
BEELINE_JDBC_URL=jdbc:hive2://${uname}:10000/default
export ALL_NODES=$(eval echo $MASTERS $SLAVES | tr ' ' \\n | sort | uniq | tr \\n ' ');
export MASTER_NODES=$(eval echo $MASTERS);
export SLAVE_NODES=$(eval echo $SLAVES);
export NN_MASTERS=$(eval echo $NN_MASTERS);
export BEELINE_JDBC_URL
