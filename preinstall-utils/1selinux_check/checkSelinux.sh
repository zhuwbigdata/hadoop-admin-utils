#!/bin/bash
echo "SELINUX should be permissive or disabled. See details in /etc/selinux/config"
/usr/sbin/getenforce
