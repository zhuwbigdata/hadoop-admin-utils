#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/../bin/setenv.sh
beeline -u "'$BEELINE_JDBC_URL'" --color=true --outputformat=tsv2 -e 'set -v' 
