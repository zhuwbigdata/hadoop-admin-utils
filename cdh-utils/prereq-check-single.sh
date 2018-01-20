#!/usr/bin/env bash

# =====================================================
# prereq-check.sh: Cloudera Manager & CDH prereq check
# =====================================================
#
# Copyright Cloudera Inc. 2015
#
# Display relevant system information and run installation prerequisite checks
# for Cloudera Manager & CDH. For details, see README.md and
# http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/installation_reqts.html.
#
# DISCLAIMER
#
# Please note: This script is released for use "AS IS" without any warranties
# of any kind, including, but not limited to their installation, use, or
# performance. We disclaim any and all warranties, either express or implied,
# including but not limited to any warranty of noninfringement,
# merchantability, and/ or fitness for a particular purpose. We do not warrant
# that the technology will meet your requirements, that the operation thereof
# will be uninterrupted or error-free, or that any errors will be corrected.
#
# Any use of these scripts and tools is at your own risk. There is no guarantee
# that they have been through thorough testing in a comparable environment and
# we are not responsible for any damage or data loss incurred with their use.
#
# You are responsible for reviewing and testing any scripts you run thoroughly
# before use in any non-testing environment.

set -e

VER=1.0.1

# checks.sh ------------------------------------------------
# Print state with coloured OK/FAIL prefix
function state() {
  local msg=$1
  local flag=$2
  if [ $flag -eq 0 ]; then
    echo -e "\e[92m PASS \033[0m $msg"
  elif [ $flag -eq 2 ]; then
    echo -e "\e[93m WARN \033[0m $msg"
  else
    echo -e "\e[91m FAIL \033[0m $msg"
  fi
}

function check_java() {
  local java=`echo "$RPM_QA" | grep "^oracle-j2sdk"`
  if [ "$java" ]; then
    local ver=`echo $java | cut -d'-' -f1-3`
    state "Java: Oracle Java installed. Actual: $ver" 0
  else
    state "Java: Oracle Java not installed" 1
  fi

  local java=`echo "$RPM_QA" | grep "^java-"`
  if [ "$java" ]; then
    #local ver=`echo $java | cut -d'-' -f1-4`
    state "Java: Unsupported Java versions installed:" 1
    for j in `echo "$java"`; do
      echo "       - $j"
    done
  else
    state "Java: No other Java versions installed" 0
  fi
}

function check_os() {
  # http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cdh_admin_performance.html#xd_583c10bfdbd326ba-7dae4aa6-147c30d0933--7fd5__section_xpq_sdf_jq
  local swappiness=`cat /proc/sys/vm/swappiness`
  local msg="System: /proc/sys/vm/swappiness should be 1"
  if [ "$swappiness" -eq 1 ]; then
    state "$msg" 0
  else
    state "$msg. Actual: $swappiness" 1
  fi

  # Older RHEL/CentOS versions use [1], while newer versions (e.g. 7.1) and
  # Ubuntu/Debian use [2]:
  #   1: /sys/kernel/mm/redhat_transparent_hugepage/defrag
  #   2: /sys/kernel/mm/transparent_hugepage/defrag.
  # http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cdh_admin_performance.html#xd_583c10bfdbd326ba-7dae4aa6-147c30d0933--7fd5__section_hw3_sdf_jq
  local file=`find /sys/kernel/mm/ -type d -name '*transparent_hugepage'`/defrag
  if [ -f $file ]; then
    local msg="System: $file should be disabled"
    if fgrep -q "[never]" $file; then
      state "$msg" 0
    else
      state "$msg. Actual: `cat $file | awk '{print $1}' | sed -e 's/\[//' -e 's/\]//'`" 1
    fi
  else
    state "System: /sys/kernel/mm/*transparent_hugepage not found. Check skipped" 2
  fi

  # http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/install_cdh_disable_selinux.html
  local msg="System: SELinux should be disabled"
  case `getenforce` in
    Disabled|Permissive) state "$msg" 0;;
    *)                   state "$msg. Actual: `getenforce`" 1;;
  esac
}

function check_database() {
  local mysql=`echo "$RPM_QA" | egrep -v "mysql-community-(common|libs|client)-" | egrep -v "mysql-(common|libs|client)-" | grep -m1 "^mysql-"`
  if [ "$mysql" ]; then
    local ver=`echo $mysql | cut -d'-' -f1-4`
  else
    state "Database: MySQL server not installed, skipping version check" 2
    return
  fi

  local major_ver=`echo $ver | cut -d'-' -f4 | cut -d'.' -f1-2`
  local msg="Database: Supported MySQL server installed. Actual: $ver"
  if [ "$major_ver" = "5.5" ] || [ "$major_ver" = "5.6" ]; then
    state "$msg" 0
  else
    state "$msg" 1
  fi
}

function check_jdbc_connector() {
  local connector=/usr/share/java/mysql-connector-java.jar
  if [ -f $connector ]; then
    state "Database: MySQL connector is installed" 0
  else
    state "Database: MySQL connector is not installed" 2
  fi
}

function check_network() {
  if [ `ping -W1 -c1 8.8.8.8 &>/dev/null; echo $?` -eq 0 ]; then
    state "Network: Has Internet connection" 0
  else
    state "Network: No Internet connection" 2
  fi

  local entries=`cat /etc/hosts | egrep -v "^#|^ *$" | wc -l`
  local msg="Network: /etc/hosts entries should be <= 2 (use DNS). Actual: $entries"
  if [ "$entries" -le 2 ]; then
    state "$msg" 0
  else
    state "$msg" 2
  fi

  # http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/install_cdh_disable_iptables.html
  _check_service_is_not_running 'Network' 'iptables'

  _check_service_is_running     'Network' 'nscd'
  _check_service_is_not_running 'Network' 'sssd'
}

function _check_service_is_running() {
  local prefix=$1
  local service=$2
  case `sudo service $service status &>/dev/null; echo $?` in
    0) state "$prefix: $service is running"       0;;
    3) state "$prefix: $service is not running"   1;;
    *) state "$prefix: $service is not installed" 1;;
  esac

  local chkconfig=`chkconfig | awk "/^$service / {print \\$5}"`
  [ "$chkconfig" ] || chkconfig=""
  if [ "$chkconfig" = "3:on" ]; then
    state "$prefix: $service auto-starts on boot" 0
  else
    state "$prefix: $service does not auto-start on boot" 1
  fi
}

function _check_service_is_not_running() {
  local prefix=$1
  local service=$2
  case `sudo service $service status &>/dev/null; echo $?` in
    0) state "$prefix: $service is running" 2
       if [ "$service" = "iptables" ]; then
         echo "       iptable routes:"
         sudo iptables -L | sed "s/^/         /"
       fi;;
    3) state "$prefix: $service is not running"   0;;
    *) state "$prefix: $service is not installed" 0;;
  esac

  local chkconfig=`chkconfig | awk "/^$service / {print \\$5}"`
  [ "$chkconfig" ] || chkconfig=""
  if [ "$chkconfig" = "3:on" ]; then
    if [ "$service" = "sssd" ]; then
      state "$prefix: $service auto-starts on boot" 2
    else
      state "$prefix: $service auto-starts on boot" 1
    fi
  else
    state "$prefix: $service does not auto-start on boot" 0
  fi
}

function check_ulimits() {
  for u in hdfs mapred hbase; do
    for t in nofile nproc; do
      local match=`grep "^$u" /etc/security/limits.d/*.conf | grep "\s$t\s"`
      local v=`echo "$match" | awk '{print $4}'`
      if [ ! "$match" ] || [ "$v"  -lt 32768 ]; then
        [ "$v" ] || v=1024
        state "System: ulimits too low. E.g. $t for '$u' should be >= 32768. Actual: $v" 1
        return
      fi
    done
  done
  state "System: ulimits for users hdfs, mapred, & hbase" 0
}

function check_hostname() {
  local fqdn=`hostname -f`
  local shortn=`hostname -s`

 if [[ `echo $fqdn | awk -F "." '{print $1}'` -eq $shortn  &&  `echo $fqdn | awk -F "." '{print NF}'` -gt 2 ]]; then
    state "Hostname: Format looks okay" 0
    return
  elif [ `echo $fqdn | awk -F '.' "{print NF}"` -lt 3 ]; then
    state "hostname: FQDN or FQDN on /etc/hosts is misconfigured. \"hostname -f\" should return the FQDN" 1
    return
  fi
}

# TODO check MySQL auto-starts on boot
# TODO check MySQL config
# TODO check hostname, DNS
# TODO check fs (type and mount options) + reserved space
function checks() {
  print_header "Prerequisite checks"
  check_os
  check_ulimits
  _check_service_is_running 'System' 'ntpd'
  check_network
  check_java
  check_database
  check_jdbc_connector
  check_hostname
}

# info.sh ------------------------------------------------
SYSINFO_TITLE_WIDTH=14

function print_label() {
  printf "%-${SYSINFO_TITLE_WIDTH}s %s\n" "$1:" "$2"
}

function print_time() {
  local timezone=`ls -lh /etc/localtime | cut -d' ' -f11 | cut -d'/' -f5-`
  timezone="${timezone:-UTC}"
  print_label "Timezone" "$timezone"
  print_label "DateTime" "`date`"
}

function print_fqdn() {
  print_label "FQDN" `hostname -f`
}

function print_os() {
  local distro="Unknown"
  if [ -f /etc/redhat-release ]; then
    distro=`sed -e 's/release //' -e 's/ (Final)//' /etc/redhat-release`
  fi
  print_label "Distro" "$distro"
  print_label "Kernel" `uname -r`
}

function print_cpu_and_ram() {
  local cpu=`grep -m1 "^model name" /proc/cpuinfo | cut -d' ' -f3- | sed -e 's/(R)//' -e 's/Core(TM) //' -e 's/CPU //'`
  print_label "CPUs" "`nproc`x $cpu"
  print_label "RAM" "`awk '/MemTotal:/ {printf "%d GB", $2/1000/1000}' /proc/meminfo`"
}

function print_disks() {
  echo "Disks:"
  for d in `ls /dev/{sd?,xvd?} 2>/dev/null`; do
    pad; echo -n "$d  "
    sudo fdisk -l $d 2>/dev/null | grep "^Disk /dev/" | cut -d' ' -f3-4 | cut -d',' -f1
  done

  local mnts=`mount | grep /data || true`
  if [ "$mnts" ]; then
    echo "Data mounts:"
    local IFS=$'\n'
    for m in `echo "$mnts"`; do
      pad; echo "$m"
    done
  else
    print_label "Data mounts" "None found"
  fi
}

function print_free_space() {
  echo "Free space:"
  free_space /opt
  free_space /var/log
}

function free_space() {
  local path=$1
  local free=`df -Ph $path | tail -1 | cut -d' ' -f7`
  pad
  printf "%-9s %s\n" $path $free
}

function print_cloudera_rpms() {
  local rpms=`echo -e "$RPM_QA" | grep "^cloudera-"`
  if [ "$rpms" ]; then
    echo "Cloudera RPMs:"
    for line in `echo $rpms`; do
      local pkg=`echo $line | cut -d'-' -f1-3`
      local ver=`echo $line | cut -d'-' -f4-`
      pad
      printf "%-24s  %s\n" "$pkg" "$ver"
    done
  else
    echo "Cloudera RPMs: None installed"
  fi
}

function print_network() {
  print_label "nsswitch" "`grep "^hosts:" /etc/nsswitch.conf | sed 's/^hosts: *//'`"
  print_label "DNS server" `grep "^nameserver" /etc/resolv.conf | cut -d' ' -f2`
}

function system_info() {
  print_header "System information"
  print_fqdn
  print_os
  print_cpu_and_ram
  print_disks
  print_free_space
  print_cloudera_rpms
  print_time
  print_network
}

# utils.sh ------------------------------------------------
function print_header() {
  echo
  echo "$*"
  echo "-------------------"
}

function pad() {
  printf "%$(($SYSINFO_TITLE_WIDTH+1))s" " "
}

# prereq-check.sh  ------------------------------------------------

echo "Cloudera Manager & CDH Prerequisites Checks v$VER"

if [ `uname` = 'Darwin' ]; then
  echo -e "\nThis tool runs on Linux only, not Mac OS."
  exit 1
fi

# Cache `rpm -qa` since it's slow and we call it several times
RPM_QA=`rpm -qa | sort`

system_info
checks
echo
