#!/bin/bash
echo "Swappiness should be set to 1 (rangen in  1-10)"
CONF_FILE=/proc/sys/vm/swappiness
cat ${CONF_FILE}
