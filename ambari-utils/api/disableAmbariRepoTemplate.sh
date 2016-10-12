#!/bin/bash
BASE_DIR=$(dirname $0)
source $BASE_DIR/setenv.sh
$AMBARI_SCRIPTS_DIR/configs.sh -u $AMBARI_ADMIN -p $AMBARI_PASS -port $AMBARI_PORT -s set $AMBARI_SERVER $AMBARI_CLUSER cluster-env "repo_suse_rhel_template" "[{{repo_id}}-X]\nname={{repo_id}}-X\n{% if mirror_list %}mirrorlist={{mirror_list}}{% else %}baseurl={{base_url}}{% endif %}\n\npath=/\nenabled=0\ngpgcheck=0"
