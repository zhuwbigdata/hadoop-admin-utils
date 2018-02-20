#!/bin/bash
AMBARI_SERVER=localhost
AMBARI_CLUSER=Sandbox
export AMBARI_SERVER
export AMBARI_CLUSER
export AMBARI_PORT=8080
export AMBARI_SCRIPTS_DIR=/var/lib/ambari-server/resources/scripts
export AMBARI_ADMIN=admin
export AMBARI_PASS=$(cat admin.pass)
