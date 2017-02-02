#!/bin/bash
check_usage() {
  if [ $# -lt 2 ];
  then
    echo "Usage:"
    echo "$0 <SERVICE_NAME, SPARK2-1> <SERVICE_TYPE, e.g. SPARK2>"
    exit 1
  fi
}
check_usage $*

BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh

generate_post_data()
{ 
  cat <<EOF 
{ "items": [ { "name": "$1", "type": "$2" } ] }
EOF
}
curl -u "${CM_ADMIN}:${CM_PASS}" -H "Content-Type:application/json" -d "$(generate_post_data $1 $2)" -i -X POST http://${CM_SERVER}:${CM_PORT}/api/${CM_VERSION}/clusters/${CM_CLUSTER}/services
