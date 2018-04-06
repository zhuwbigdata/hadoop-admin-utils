#!/bin/bash
DB_HOST=prodva-hdpmysql01.cvd1bs9puypk.us-east-1.rds.amazonaws.com
DB_PORT=3306
CMF_USER=qiqhxwlw
CMF_PW=d1528e1a-b14b-4646-8153-33010807dc98
CMF_DB=scm_no6r9squa7chlqo5pndh442m1l
NAV_USER=nav
NAV_PW=nav
NAV_DB=nav_johh9kln2e02ord73esn9kni51
NAVMS_USER=navmeta
NAVMS_PW=navmeta
NAVMS_DB=navmeta_ci9mh5lcr2atd0gidherbmglmq
AMON_USER=amon
AMON_PW=amon
AMON_DB=am_q9vjq233jn02r2jnc9b21prfln
RMAN_USER=vujhiifq
RMAN_PW=7e2cbbf3-40e7-4ab2-b0be-bef5f863b014
RMAN_DB=rm_s108da3fdgdfuap9kivvd9s35u

mysqldump --host=${DB_HOST} --port=${DB_PORT}  --user=${CMF_USER}   --password=${CMF_PW}   ${CMF_DB}   > scm-backup.sql
mysqldump --host=${DB_HOST} --port=${DB_PORT}  --user=${NAV_USER}   --password=${NAV_PW}   ${NAV_DB}   > nav-backup.sql
mysqldump --host=${DB_HOST} --port=${DB_PORT}  --user=${NAVMS_USER} --password=${NAVMS_PW} ${NAVMS_DB} > navms-backup.sql
mysqldump --host=${DB_HOST} --port=${DB_PORT}  --user=${AMON_USER}  --password=${AMON_PW}  ${AMON_DB}  > amon-backup.sql
mysqldump --host=${DB_HOST} --port=${DB_PORT}  --user=${RMAN_USER}  --password=${RMAN_PW}  ${RMAN_DB}  > rman-backup.sql
