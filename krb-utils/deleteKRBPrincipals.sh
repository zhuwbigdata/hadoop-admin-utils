#!/bin/bash
check_usage() {
  if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "$0  [krb_principals_file, one principal per line]"
    exit 1
  fi
}
check_usage $*
KRB_PRINCS_FILE=$1
KRB_ADMIN_USER=$(cat .krb_admin_user)
KRB_ADMIN_PASS=$(cat .krb_admin_pass)
while IFS= read -r line
do
    kadmin  -p ${KRB_ADMIN_USER} -w ${KRB_ADMIN_PASS}  -q "delete_principal -force ${line}"
done <  ${KRB_PRINCS_FILE}
