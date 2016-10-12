#!/bin/bash
uname=$(uname -n)
MASTERS='mastersi00{1..5}'
SLAVES='slaves00{1..10}'
NODES="$MASTERS $SLAVES"
export NODES_LIST=$(eval echo $NODES);
