#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
check_usage() {
  if [ $# -lt 3 ]
  then
    echo "Usage:"
    echo "$0  <username> <table_name> <output_dir>"
    exit 1
  fi
}
export SQOOP_DELIM='\001'           #use Hive default field delimiter for import
export SQOOP_NUM_MAPPERS=1         #change to 4 mappers for small tables
export SQOOP_NULL_STRING=' '       #use Hive default
export SQOOP_NULL_NON_STRING=' '   #use Hive default
sqoop import  --connect $SQOOP_JDBC_URL --username $1 -P   --fields-terminated-by "$SQOOP_DELIM" --null-string "$SQOOP_NULL_STRING" --null-non-string "$SQOOP_NULL_NON_STRING" --num-mappers $SQOOP_NUM_MAPPERS --table $2 --target-dir $3
