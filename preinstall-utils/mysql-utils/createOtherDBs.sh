#!/bin/bash
# http://www.cloudera.com/documentation/enterprise/latest/topics/cm_ig_mysql.html#concept_dsg_3mq_bl
check_usage() {
  if [ $# -lt 2 ]
  then
    echo "Usage:"
    echo "$0  <DB_NAME> <USER_NAME>"
    exit 1
  fi
}
check_usage $*
echo "CREATE DATABASE  ${1} DEFAULT CHARACTER SET utf8;"
echo "GRANT ALL ON ${1}.* TO '${2}'@'%' IDENTIFIED BY '${2}1234';"
echo "EXIT;"
