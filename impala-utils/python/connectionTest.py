from impala.dbapi import connect
conn = connect(host='', use_ssl=True, auth_mechanism='GSSAPI', kerberos_service_name='impala')
cur = conn.cursor()
cur.execute('SHOW DATABASES')
cur.fetchall()
exit()
