#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
/usr/bin/oozie jobs -oozie $OOZIE_URI 
