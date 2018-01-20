#!/usr/bin/env bash

function log() {
    local msg=$1
    local opts=$2
    local time=`date +%H:%M:%S`
    echo $opts "$time $msg"
}

function kernel_tuning() {
# Kernel tuning
# Disable Swap

log "**** Tuning Swap"

echo 1 > /proc/sys/vm/swappiness
echo 'vm.swappiness = 1' >> /etc/sysctl.conf


log "**** Tuning Transparent Huge Pages"
# Disable THP
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local


log "**** Disabling Firewall"
# Disable IPTables/Firewalld
systemctl stop firewalld
systemctl disable firewalld


log "**** Increasing number of open files and number of processes"
# Increase userlimits
echo  hdfs    -  nofile  32768  >>  /etc/security/limits.conf
echo  mapred  -  nofile  32768  >>  /etc/security/limits.conf
echo  hbase   -  nofile  32768  >>  /etc/security/limits.conf
echo  hdfs    -  nproc   32768  >>  /etc/security/limits.conf
echo  mapred  -  nproc   32768  >>  /etc/security/limits.conf
echo  hbase   -  nproc   32768  >>  /etc/security/limits.conf
}

function install_package () {
log "**** Installing required packages"
yum -y install httpd
yum -y install nscd
yum -y install ntp
}

function configure_services() {
# start NTP
log "**** Starting NTP service"
systemctl start ntpd
systemctl enable ntpd
# nsswitch fix name resolution order and deploy a nameserver
# 
# log "**** Setting up connection to DNS server"
#echo "nameserver 192..." > /etc/resolv.conf
#sed -i "s/files dns/dns files/g" /etc/nsswitch.conf

# Disable SeLinux
log "**** Disabling SELinux"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

}

kernel_tuning
install_package
configure_services

# remove existing java version (openjdk)
# Setup OS yum repository

