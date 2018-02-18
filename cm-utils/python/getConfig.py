#!/usr/bin/python
# Get a handle to the API client
import ssl
import sys
import pprint
import argparse
from cm_api.api_client import ApiResource, ApiException
from cm_api.endpoints.services import ApiService, ApiServiceSetupInfo



def main(cm_host, cm_user_login, cm_user_passwd, cluster_name):
  #cm_host = 'localhost'
  #cm_user_login  = 'cmnjro'
  #cm_user_passwd = 'John3:16'
  #cm_api_version = 18
  #cluster_name = 'cluster'

  zk_service_type = 'ZOOKEEPER'
  zk_service_role_type_server = 'SERVER'
  hdfs_service_type = 'HDFS'
  hdfs_service_role_type_namenode = 'NAMENODE'
  yarn_service_type = 'YARN'
  yarn_service_role_type_namenode = 'RESOURCEMANAGER'
  oozie_service_type = 'OOZIE'
  oozie_service_role_type_server = 'OOZIE_SERVER'

SERVICE_ROLE_MAP = {
    'zookeeper': 'ZOOKEEPER-SERVER-BASE',
    'datanode': 'HDFS-DATANODE-BASE',
    'namenode': 'HDFS-NAMENODE-BASE',
}







#context = ssl.create_default_context(cafile='/opt/cloudera/security/certs/ChainedCA.cert.pem')
#api = ApiResource(cm_host, username=cm_user_login, password=cm_user_passwd, version=cm_api_version, use_tls=True, ssl_context=context)
api = ApiResource(server_host=cm_host, username=cm_user_login, password=cm_user_passwd)

# Get a list of all clusters
cdh_cluster = None
host_id2name_map = {}
host_name2id_map = {}
zk_service = None
zk_service_role_list = None
zk_host_list = []
hdfs_service = None
hdfs_service_role_list = None
hdfs_host_list = []
yarn_service = None
yarn_service_role_list = None
yarn_host_list = []
oozie_service = None
oozie_service_role_list = None
oozie_host_list = []

for c in api.get_all_clusters():
#  if c.name == cluster_name:
    print c
    cdh_cluster = c
    for x in cdh_cluster.list_hosts():
      host_name2id_map[api.get_host(x.hostId).hostname] =  x.hostId
      host_id2name_map[x.hostId] = api.get_host(x.hostId).hostname
    for x in cdh_cluster.get_all_services():
      print x.type
    for x in host_name2id_map:
      print  x, host_name2id_map[x]
    for x in host_id2name_map:
      print  x, host_id2name_map[x]


for s in cdh_cluster.get_all_services():
  if s.type == zk_service_type:
    print 'SERVICE:', s.type, s.get_config()
    zk_service = s
    zk_service_role_group_list  = zk_service.get_all_role_config_groups()
    for x in zk_service_role_group_list:
      print 'ROLE_GROUP:', x.roleType,
      for key,val  in x.get_config(view='full').items():
        print key,':', val.name,'/', val.value
    zk_service_role_list =  zk_service.get_all_roles()
    for x in zk_service_role_list:
      print 'ROLE:', x.type, x.get_config()
      if x.type == zk_service_role_type_server:
        zk_host_list.append(host_id2name_map[x.hostRef.hostId])
        #print x.to_json_dict()
    for x in zk_host_list:
      print x
  elif s.type == hdfs_service_type:
    print s
    hdfs_service = s
    hdfs_service_role_list =  hdfs_service.get_all_roles()
    for x in hdfs_service_role_list:
      if x.type == hdfs_service_role_type_namenode:
        hdfs_host_list.append(host_id2name_map[x.hostRef.hostId])
        #print x.to_json_dict()
    for x in hdfs_host_list:
      print x
  elif s.type == yarn_service_type:
    print s
    yarn_service = s
    yarn_service_role_list =  yarn_service.get_all_roles()
    for x in yarn_service_role_list:
      if x.type == yarn_service_role_type_namenode:
        yarn_host_list.append(host_id2name_map[x.hostRef.hostId])
        #print x.to_json_dict()
    for x in hdfs_host_list:
      print x
  elif s.type == oozie_service_type:
    print s
    oozie_service = s
    oozie_service_role_list =  oozie_service.get_all_roles()
    for x in oozie_service_role_list:
      if x.type == oozie_service_role_type_server:
        oozie_host_list.append(host_id2name_map[x.hostRef.hostId])
        #print x.to_json_dict()
    for x in oozie_host_list:
      print x


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='get configuration from Cloudera Manager API')
  parser.add_argument('--cm_fqhn', required=True,
                        help='Cloudera Manager FQHN')
  parser.add_argument('--cm_user_name', required=True,
                        help='Cloudera Manager User Name (admin/clusteradmin)')
  parser.add_argument('--cm_user_password', required=True,
                        help='Cloudera Manager User Password')
  parser.add_argument('--cm_cluster_name', required=True,
                        help='Cloudera Manager Cluster Name')
  args = parser.parse_args()
  main(cm_host = args.cm_fqhn, 
       cm_user_name = args.cm_user_name, 
       cm_user_password = args.cm_user_password,
       cm_cluster_cluster = args.cm_cluster_name)
