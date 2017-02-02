#!/bin/bash
CM_SERVER=$(uname -n)
CM_CLUSTER=sandbox
export CM_SERVER;
export CM_PORT=7180
export CM_VERSION=v13
export CM_CLUSTER=Cloudera%20QuickStart
export CM_ADMIN=admin
export CM_PASS=$(cat admin.pass)
