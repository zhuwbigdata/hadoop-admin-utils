#!/bin/bash
echo "Enabled: [always] never | Disabled: always [never]"
CONF_FILE=/sys/kernel/mm/transparent_hugepage/defrag
if [ -f ${CONF_FILE} ]; then
  if cat ${CONF_FILE} | grep -q '\[never\]' ; then
      echo  "Hugepage is disabled."
  else
      echo  "Hugepage is still enabled."
      echo  "Please check /etc/rc.d/rc.local and add the line as follows:"
      echo  "echo never > /sys/kernel/mm/transparent_hugepage/defrag" 
      echo  "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
  fi
fi

