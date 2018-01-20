#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
/usr/bin/impala-shell -k -i $IMPALA_URI --quiet
