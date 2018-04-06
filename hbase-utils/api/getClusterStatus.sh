#!/bte -u : 'in/bash
check_usage() {
  if [ $# -lt 1 ];
  then
    echo "Usage:"
    echo "$0 <SERVICE_NAME>"
    exit 1
  fi
}
check_usage $*
/usr/bin/curl --insecure --negotiate -u :  ${HTTP_PROTOCOL}://${HBASE_RESTSVR_HOST}:${HBASE_RESTSVR_PORT}/status/cluster
export HBASE_RESTSVR_HOST=

