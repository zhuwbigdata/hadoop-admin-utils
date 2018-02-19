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
  'oozie': 'OOZIE',
}

    
SERVICE_ROLE_TYPE_MAP = {
  'zookeeper_server': 'SERVER',
  'namenode':  'NAMENODE',
  'resourcemanager':  'RESOURCEMANAGER',
  'oozie_server': 'OOZIE_SERVER'
}

CONFIG_KEY_VALUE_MAP = {
  'NAME_NODE': None,    
  'NAME_NODE_PORT': '8020',
  'JOB_TRACKER': None,  
  'RESOURCEMANAGER_ADDRESS': '8032',
  'OOZIE_URL': None,    
  'OOZIE_HTTP_PORT': '11000',
  'OOZIE_HTTPS_PORT': '11443',
  'OOZIE_USE_SSL': 'false',
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
  'oozie_http_port': 'oozie_http_port',
  'oozie_https_port':  'oozie_https_port',
  'oozie_use_ssl':  'oozie_use_ssl',
  'oozie_load_balancer': 'oozie_load_balancer',
}

HOST_NAME2ID_MAP = {}
HOST_ID2NAME_MAP = {} 


def inspectConfigByService(serviceRef):
  service_config_list = serviceRef.get_config(view='full')
  for key, value in service_config_list[0].items():
    print key, value
    
def getValueByKeyServiceConfig(serviceRef, key_in):
  value_out = None
  service_config_list = serviceRef.get_config(view='full')
  for key, config in service_config_list[0].items():
    #print key, value
    if key == key_in:
      value_out = config.value 
  return value_out
        
        
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


def inspectRolesByService(serviceRef):
  service_role_list =  serviceRef.get_all_roles()
  for x in service_role_list:
    print 'ROLE name:', x.name, 'type:', x.type, 'hostId:', x.hostRef.hostId
    

def getHostsByServiceAndRoleType(serviceRef, role_type):
  hosts_out = []
  service_role_list =  serviceRef.get_all_roles()
  for x in service_role_list:
    #print 'ROLE name:', x.name, 'type:', x.type, 'hostId:', x.hostRef.hostId
    if x.type == role_type:
      hosts_out.append(HOST_ID2NAME_MAP[x.hostRef.hostId])
      #print x.to_json_dict()
  return hosts_out

def main(cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name, cm_tls_enabled, cm_tls_cafile): 
  #print  cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name, cm_tls_enabled, cm_tls_cafile
  if cm_tls == 'false':
    api = ApiResource(server_host=cm_fqhn, username=cm_user_name, password=cm_user_password) 
  else: 
    #context = ssl.create_default_context(cafile='/opt/cloudera/security/certs/ChainedCA.cert.pem')
    context = ssl.create_default_context(cafile=cm_tls_cafile)
    api = ApiResource(server_host=cm_fqhn, username=cm_user_name, password=cm_user_password, use_tls=True, ssl_context=context)

  
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
      zk_server_rcg      = getRCGByServiceAndRoleType(zk_service, SERVICE_ROLE_TYPE_MAP['zookeeper_server'])
      zk_client_port = geValueByKeyInRCG(zk_server_rcg, CONFIG_PROPERTY_MAP['zk_client_port'])
      if zk_client_port != None:
        CONFIG_KEY_VALUE_MAP['ZOOKEEPER_PORT'] = zk_client_port
      zk_hosts = getHostsByServiceAndRoleType(zk_service, SERVICE_ROLE_TYPE_MAP['zookeeper_server'])
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
      #inspectRolesByService(yarn_service)
      #inspectRCGs(yarn_service)
      yarn_jt_rcg      = getRCGByServiceAndRoleType(yarn_service, SERVICE_ROLE_TYPE_MAP['resourcemanager'])
      #inspectKVsInRCG(yarn_jt_rcg)
      yarn_rm_address = geValueByKeyInRCG(yarn_jt_rcg, CONFIG_PROPERTY_MAP['yarn_rm_address'])
      if yarn_rm_address == None:
        yarn_rm_address = CONFIG_KEY_VALUE_MAP['RESOURCEMANAGER_ADDRESS']
      else: 
        CONFIG_KEY_VALUE_MAP['RESOURCEMANAGER_ADDRESS'] = yarn_rm_address
      rm_hosts = getHostsByServiceAndRoleType(yarn_service, SERVICE_ROLE_TYPE_MAP['resourcemanager'])
      #print 'YARN RESOURCEMANGER HOSTS:', rm_hosts
      CONFIG_KEY_VALUE_MAP['JOB_TRACKER'] = rm_hosts[0] + ':' + yarn_rm_address
    
      #OOZIE
      oozie_service  = getServiceByServiceType(cdh_cluster, SERVICE_TYPE_MAP['oozie'])
      inspectConfigByService(oozie_service)
      oozie_use_ssl = getValueByKeyServiceConfig(oozie_service, CONFIG_PROPERTY_MAP['oozie_use_ssl'])
      print 'OOZIE TLS/SSL:', oozie_use_ssl
      if oozie_use_ssl == 'true':
        CONFIG_KEY_VALUE_MAP['OOZIE_USE_SSL'] = 'true'
      oozie_LB = getValueByKeyServiceConfig(oozie_service, CONFIG_PROPERTY_MAP['oozie_load_balancer'])
        
      #inspectRolesByService(oozie_service)
      #inspectRCGs(oozie_service)
      oozie_server_rcg      = getRCGByServiceAndRoleType(oozie_service, SERVICE_ROLE_TYPE_MAP['oozie_server'])
      #inspectKVsInRCG(oozie_server_rcg)
      oozie_http_port  = geValueByKeyInRCG(oozie_server_rcg, CONFIG_PROPERTY_MAP['oozie_http_port'])
      oozie_https_port = geValueByKeyInRCG(oozie_server_rcg, CONFIG_PROPERTY_MAP['oozie_https_port'])
      if oozie_http_port == None:
        oozie_http_port = CONFIG_KEY_VALUE_MAP['OOZIE_HTTP_PORT']
      if oozie_https_port == None:
        oozie_https_port = CONFIG_KEY_VALUE_MAP['OOZIE_HTTPS_PORT']  
      print 'OOOZIE http(s) ports:', oozie_http_port, oozie_https_port
      oozie_hosts = getHostsByServiceAndRoleType(oozie_service, SERVICE_ROLE_TYPE_MAP['oozie_server'])
      print oozie_hosts
    
      
      if CONFIG_KEY_VALUE_MAP['OOZIE_USE_SSL'] == 'true':
        if oozie_LB != None:
          CONFIG_KEY_VALUE_MAP['OOZIE_URL'] = 'https://' + oozie_LB
        else:
          CONFIG_KEY_VALUE_MAP['OOZIE_URL'] = 'http://' + oozie_hosts[0] + ':' + CONFIG_KEY_VALUE_MAP['OOZIE_HTTPS_PORT'] + '/oozie'
      else:
        if oozie_LB != None:
          CONFIG_KEY_VALUE_MAP['OOZIE_URL'] = 'http://' + oozie_LB
        else:
          CONFIG_KEY_VALUE_MAP['OOZIE_URL'] = 'http://' + oozie_hosts[0] + ':' + CONFIG_KEY_VALUE_MAP['OOZIE_HTTP_PORT'] + '/oozie'
    
      
                                           
      # Print all
      print CONFIG_KEY_VALUE_MAP
        
        
        
        
        
        

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='get configuration from Cloudera Manager API')
 
  parser.add_argument('--cm_fqhn', required=True,
                        help='Cloudera Manager FQHN')
  parser.add_argument('--cm_user_name', required=True,
                        help='Cloudera Manager User Name')
  parser.add_argument('--cm_user_password', required=True,
                        help='Cloudera Manager User Password')
  parser.add_argument('--cm_cluster_name', required=True,
                        help='Cloudera Manager Cluster Name')
  parser.add_argument('--cm_tls', required=True,
                        help='Cloudera Manager TLS enabled')
  parser.add_argument('--cm_tls_cafile', required=False,
                        help='Cloudera Manager TLS CA file location')
  args = parser.parse_args()
  main(cm_fqhn = args.cm_fqhn, 
       cm_user_name = args.cm_user_name, 
       cm_user_password = args.cm_user_password,
       cm_cluster_name = args.cm_cluster_name,
       cm_tls = args.cm_tls,
       cm_tls_cafile = args.cm_tls_cafile)
