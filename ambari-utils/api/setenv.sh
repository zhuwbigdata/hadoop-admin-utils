#!/bin/bash
#AMBARI_SERVER=localhost
AMBARI_SERVER='172.16.95.169'
AMBARI_CLUSTER=Sandbox
export AMBARI_SERVER
export AMBARI_CLUSER
export AMBARI_PORT=8080
export AMBARI_SCRIPTS_DIR=/var/lib/ambari-server/resources/scripts
export AMBARI_ADMIN=admin
export AMBARI_PASS=$(cat admin.pass)
