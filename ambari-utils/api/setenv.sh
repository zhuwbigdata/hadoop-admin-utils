#!/bin/bash
uname=$(uname -n)
AMBARI_SERVER=localhost
AMBARI_CLUSER=sandbox
export AMBARI_SERVER;
export AMBARI_CLUSER;
export AMBARI_PORT=8443;
export AMBARI_SCRIPTS_DIR=/var/lib/ambari-server/resources/scripts
export AMBARI_ADMIN=admin
export AMBARI_PASS=$(cat admin.pass)
