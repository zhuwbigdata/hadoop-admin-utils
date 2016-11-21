#!/bin/bash
echo "Enabled: [always] never | Disabled: always [never]"
CONF_FILE=/sys/kernel/mm/transparent_hugepage/defrag
if [ -f ${CONF_FILE} ]; then
  if cat ${CONF_FILE} | grep -q '\[never\]' ; then
      echo  "Hugepage is disabled."
  else
      echo  "Hugepage is still enabled. Please check /etc/rc.d/rc.local"
  fi
fi

