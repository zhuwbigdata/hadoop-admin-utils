#!/usr/bin/python
# Get a handle to the API client
import ssl
import sys
import pprint
import argparse
from cm_api.api_client import ApiResource, ApiException
from cm_api.endpoints.services import ApiService, ApiServiceSetupInfo

SERVICE_TYPE_MAP = {
  'zookeeper': 'ZOOKEEPER',
  'hdfs': 'HDFS',
  'hbase': 'HBASE',
  'yarn': 'YARN',
}

SERVICE_ROLE_TYPE_MAP = {
  'zookeeper': 'SERVER',
  'namenode':  'NAMENODE',
  'resourcemanager':  'RESOURCEMANAGER',
}

CONFIG_KEY_VALUE_MAP = {
  'NAME_NODE': None,    
  'NAME_NODE_PORT': '8020',
  'JOB_TRACKER': None,  
  'RESOURCEMANAGER_ADDRESS': 8032,
  'OOZIE_URL': None,                                                                                    
  'ZOOKEEPER_QUORUM': None,                                                               
  'ZOOKEEPER_PORT': '2181',                                                                      
  'KAFKA_SECURITY_PROTOCOL': None,                                                             
  'HBASE_REST_IP': None,                                                                   
  'HBASE_REST_PORT': None,                                                                   
  'KAFKA_BROKER': None,                
}

CONFIG_PROPERTY_MAP = {
  'zk_client_port': 'clientPort',
  'hdf_nn_ns': 'dfs_federation_namenode_nameservice',
  'hdf_nn_port': 'namenode_port',
  'yarn_rm_address':  'yarn_resourcemanager_addres',
}

HOST_NAME2ID_MAP = {}
HOST_ID2NAME_MAP = {} 

def getServiceByServiceType(clusterRef, service_type):
  service_out = None
  for s in clusterRef.get_all_services():
    if s.type == service_type:
      service_out = s
  return service_out

def inspectRCGs(serviceRef):
  service_role_group_list  = serviceRef.get_all_role_config_groups()
  for x in service_role_group_list:
    print x.roleType, x

def getRCGByServiceAndRoleType(serviceRef, role_type):
  rcg_out = None
  service_role_group_list  = serviceRef.get_all_role_config_groups()
  for x in service_role_group_list:
    if x.roleType == role_type:
      rcg_out = x
  print rcg_out
  return rcg_out


def inspectKVsInRCG(rcgRef):
  for key, val  in rcgRef.get_config(view='full').items():
    print  'Key:', key, 'Value:', val
 

def geValueByKeyInRCG(rcgRef, key_in):
  value_out = None
  for key, val  in rcgRef.get_config().items():
    #print  'Key:', key, 'Value:', val
    if key == key_in:
        value_out = val
  return value_out

def getKeyValueByServiceTypeAndRoleType(clusterRef, service_type, role_type, key_in):
  value_out = None
  for s in clusterRef.get_all_services():
    if s.type == service_type:
      #print 'SERVICE:', s.type, s.get_config()
      service_role_group_list  = s.get_all_role_config_groups()
      for x in service_role_group_list:
        if x.roleType == role_type:
          print 'ROLE_GROUP:', 'type:', x.roleType, 'name:', x.name
          for key, val  in x.get_config().items():
            #print  'Key:', key, 'Value:', val
            if key == key_in:
                value_out = val
  return value_out

def getHostsByServiceAndRoleType(serviceRef, role_type):
  hosts_out = []
  print serviceRef
  print role_type
  service_role_list =  serviceRef.get_all_roles()
  for x in service_role_list:
    #print 'ROLE name:', x.name, 'type:', x.type, 'hostId:', x.hostRef.hostId
    if x.type == role_type:
      hosts_out.append(HOST_ID2NAME_MAP[x.hostRef.hostId])
      #print x.to_json_dict()
  return hosts_out

def main(cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name): 
  #print cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name
  api = ApiResource(server_host=cm_fqhn, username=cm_user_name, password=cm_user_password)  
  
  # Get a list of all clusters
  cdh_cluster = None
  
  for c in api.get_all_clusters():
    if c.name == cm_cluster_name:
      print '\nCluster:', c
      cdh_cluster = c
      for x in cdh_cluster.list_hosts():
        HOST_NAME2ID_MAP[api.get_host(x.hostId).hostname] =  x.hostId
        HOST_ID2NAME_MAP[x.hostId] = api.get_host(x.hostId).hostname 
      print '\nHostName to HostId Mapping:'
      for x in HOST_NAME2ID_MAP:
        print  x, HOST_NAME2ID_MAP[x]
      print '\nHostId to HostName Mapping:'
      for x in HOST_ID2NAME_MAP:
        print  x, HOST_ID2NAME_MAP[x]
      print '\nServices:'
      for x in cdh_cluster.get_all_services():
        print x.type
      
      #ZooKeeper
      #zk_client_port = getKeyValueByServiceTypeAndRoleType(cdh_cluster, 
      #                                    SERVICE_TYPE_MAP['zookeeper'], 
      #                                    SERVICE_ROLE_TYPE_MAP['zookeeper'],
      #                                    'clientPort');
      zk_service  = getServiceByServiceType(cdh_cluster, SERVICE_TYPE_MAP['zookeeper'])
      zk_server_rcg      = getRCGByServiceAndRoleType(zk_service, SERVICE_ROLE_TYPE_MAP['zookeeper'])
      zk_client_port = geValueByKeyInRCG(zk_server_rcg, CONFIG_PROPERTY_MAP['zk_client_port'])
      if zk_client_port != None:
        CONFIG_KEY_VALUE_MAP['ZOOKEEPER_PORT'] = zk_client_port
      zk_hosts = getHostsByServiceAndRoleType(zk_service, SERVICE_ROLE_TYPE_MAP['zookeeper'])
      print 'ZOOKEEPER HOSTS:', zk_hosts
      if len(zk_hosts) > 0:
         CONFIG_KEY_VALUE_MAP['ZOOKEEPER_QUORUM'] = ' '.join(zk_hosts)
     
      #HDFS
      hdfs_service  = getServiceByServiceType(cdh_cluster, SERVICE_TYPE_MAP['hdfs'])
      hdfs_nn_rcg      = getRCGByServiceAndRoleType(hdfs_service, SERVICE_ROLE_TYPE_MAP['namenode'])
      #inspectKVsInRCG(hdfs_nn_rcg)
      hdfs_nn_ns = geValueByKeyInRCG(hdfs_nn_rcg, CONFIG_PROPERTY_MAP['hdf_nn_ns'])
      print 'HDFS NAMENODE NAMESERVICE:', hdfs_nn_ns
      hdfs_nn_port = geValueByKeyInRCG(hdfs_nn_rcg, CONFIG_PROPERTY_MAP['hdf_nn_port'])
      print 'HDFS NAMENODE PORT:', hdfs_nn_port
      if hdfs_nn_port == None:
        hdfs_nn_port = CONFIG_KEY_VALUE_MAP['NAME_NODE_PORT']
      else: 
        CONFIG_KEY_VALUE_MAP['NAME_NODE_PORT'] = hdfs_nn_port
      nn_hosts = None
      if hdfs_nn_ns == None:
        nn_hosts = getHostsByServiceAndRoleType(hdfs_service, SERVICE_ROLE_TYPE_MAP['namenode'])
        print 'HDFS NAMENODE HOSTS:', nn_hosts
        CONFIG_KEY_VALUE_MAP['NAME_NODE'] = 'hdfs://' + nn_hosts[0] + ':' + hdfs_nn_port
      else:
        CONFIG_KEY_VALUE_MAP['NAME_NODE'] = hdfs_nn_ns
        
      #YARN
      yarn_service  = getServiceByServiceType(cdh_cluster, SERVICE_TYPE_MAP['yarn'])
      #inspectRCGs(yarn_service)
      yarn_jt_rcg      = getRCGByServiceAndRoleType(yarn_service, SERVICE_ROLE_TYPE_MAP['resourcemanager'])
      #inspectKVsInRCG(yarn_jt_rcg)
      yarn_rm_address = geValueByKeyInRCG(yarn_jt_rcg, CONFIG_PROPERTY_MAP['yarn_rm_address'])
      if yarn_rm_address == None:
        yarn_rm_address = CONFIG_KEY_VALUE_MAP['RESOURCEMANAGER_ADDRESS']
      else: 
        CONFIG_KEY_VALUE_MAP['RESOURCEMANAGER_ADDRESS'] = yarn_rm_address
      rm_hosts = getHostsByServiceAndRoleType(hdfs_service, SERVICE_ROLE_TYPE_MAP['resourcemanager'])
      print 'YARN RESOURCEMANGER HOSTS:', rm_hosts
      CONFIG_KEY_VALUE_MAP['JOB_TRACKER'] = rm_hosts[0] + ':' + yarn_rm_address
    
        
      # Print all
      print CONFIG_KEY_VALUE_MAP
        
        
        
        
        
        

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
  main(cm_fqhn = args.cm_fqhn, 
       cm_user_name = args.cm_user_name, 
       cm_user_password = args.cm_user_password,
       cm_cluster_name = args.cm_cluster_name)
