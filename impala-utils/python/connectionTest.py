from impala.dbapi import connect
conn = connect(host='prodva-hdpcm01.miop.aws', use_ssl=True, auth_mechanism='GSSAPI', kerberos_service_name='impala')
cur = conn.cursor()
cur.execute('SHOW DATABASES')
print cur.fetchall()
exit()
