#!/bin/bash
echo "Enabled=0 AND Disabled=1"
/usr/sbin/sysctl net.ipv6.conf.all.disable_ipv6 
/usr/sbin/sysctl net.ipv6.conf.lo.disable_ipv6
