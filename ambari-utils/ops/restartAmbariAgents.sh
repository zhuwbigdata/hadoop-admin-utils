#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
for i in $NODES_LIST; 
do 
  echo $i; 
  ssh -t $i 'dzdo /usr/sbin/ambari-agent restart'; 
done
