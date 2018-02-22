#!/usr/local/bin/python
#/usr/bin/python
# Get a handle to the API client
import ssl
import sys
import pprint
import argparse
from ambariclient.client import Ambari
from configs import api_accessor, get_properties2

SERVICE_NAME_MAP = {
  'zookeeper': 'ZOOKEEPER',
  'hdfs': 'HDFS',
  'hbase': 'HBASE',
  'yarn': 'YARN',
  'oozie': 'OOZIE',
  'hbase': 'HBASE',
  'kafka': 'KAFKA',
}

CONFIG_TYPE_MAP = {
  'hdfs': 'hdfs-site',
  'yarn': 'yarn-site',
  'hbase': 'hbase-site',
  'kafka': 'kafka-broker',
  'oozie': 'oozie-site',
  'zookeeper': 'zoo.cfg',
}

    
SERVICE_COMPONENT_NAME_MAP = {
  'zookeeper_server': 'ZOOKEEPER_SERVER',
  'namenode':  'NAMENODE',
  'resourcemanager':  'RESOURCEMANAGER',
  'oozie_server': 'OOZIE_SERVER',
  'hbase_restserver': 'HBASERESTSERVER',
  'kafka_broker': 'KAFKA_BROKER',
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
  'HBASE_REST_IP': None,                                                                   
  'HBASE_REST_PORT': '20550',                                                                 
  'KAFKA_BROKER': None,    
  'KAFKA_SECURITY_PROTOCOL': 'PLAINTEXT',  
}

CONFIG_PROPERTY_MAP = {
  'zk_client_port': 'clientPort',
  'hdf_nn_ns': 'dfs.nameservices',
  'hdf_nn_rpc': 'dfs.namenode.rpc-address',
  'yarn_rm_address':  'yarn.resourcemanager.address',
  'oozie_base_url': 'oozie.base.url',
  'oozie_load_balancer': 'oozie_load_balancer',
  'hbase_rs_port': 'hbase_restserver_port',
  'hbase_rs_host': 'hbase_restserver_host',
  'kafka_client_security_protocol': 'security.inter.broker.protocol',
}

HOST_MAP = {} 



def main(cm_fqhn, cm_port, cm_user_name, cm_user_password, cm_cluster_name, cm_tls_enabled):
  print  cm_fqhn, cm_port, cm_user_name, cm_user_password, cm_cluster_name, cm_tls_enabled
  
  cm_protocol = 'https'
  if cm_tls_enabled.lower() == 'false':
    cm_protocol = 'http'
  #print 'Protocol:', cm_protocol
  ambari_accessor = api_accessor(host=cm_fqhn, 
                                 login=cm_user_name, 
                                 password=cm_user_password, 
                                 protocol=cm_protocol, 
                                 port=cm_port)
    
  zookeeper_config = get_properties2(cluster=cm_cluster_name, 
                                     config_type=CONFIG_TYPE_MAP['zookeeper'],
                                     accessor=ambari_accessor)
  zk_client_port = zookeeper_config.get(CONFIG_PROPERTY_MAP['zk_client_port'])
  if zk_client_port != None:
        CONFIG_KEY_VALUE_MAP['ZOOKEEPER_PORT'] = zk_client_port

  hdfs_site_config = get_properties2(cluster=cm_cluster_name, 
                                     config_type=CONFIG_TYPE_MAP['hdfs'],
                                     accessor=ambari_accessor)
  #print "\nHDFS-SITE:\n", hdfs_site_config  
  hdfs_nn_ns = hdfs_site_config.get(CONFIG_PROPERTY_MAP['hdf_nn_ns'], None)
  hdfs_nn_rpc = hdfs_site_config.get(CONFIG_PROPERTY_MAP['hdf_nn_rpc'])
  print '\nHDFS-SITE:', hdfs_nn_ns, hdfs_nn_rpc
  if hdfs_nn_ns == None:
        CONFIG_KEY_VALUE_MAP['NAME_NODE'] = 'hdfs://' + hdfs_nn_rpc
  else:
        CONFIG_KEY_VALUE_MAP['NAME_NODE'] = hdfs_nn_ns

  yarn_site_config = get_properties2(cluster=cm_cluster_name, 
                                     config_type=CONFIG_TYPE_MAP['yarn'],
                                     accessor=ambari_accessor)
  #print "\nYARN-SITE:\n", yarn_site_config
  yarn_rm_address = yarn_site_config.get(CONFIG_PROPERTY_MAP['yarn_rm_address'])
  CONFIG_KEY_VALUE_MAP['JOB_TRACKER'] = yarn_rm_address  
    
  hbase_site_config = get_properties2(cluster=cm_cluster_name, 
                                     config_type=CONFIG_TYPE_MAP['hbase'],
                                     accessor=ambari_accessor)
  #print "\nHBASE-SITE:\n", hbase_site_config
                                                             
                                                             
  kafka_broker_config = get_properties2(cluster=cm_cluster_name, 
                                     config_type=CONFIG_TYPE_MAP['kafka'],
                                     accessor=ambari_accessor)
  #print "\nKAFAKA_BROKER:\n", kafka_broker_config
  kafka_client_security_protocol = kafka_broker_config.get(CONFIG_PROPERTY_MAP['kafka_client_security_protocol'])
  #print 'Kafka protocol:', kafka_client_security_protocol
  if kafka_client_security_protocol != None:
        CONFIG_KEY_VALUE_MAP['KAFKA_SECURITY_PROTOCOL'] = kafka_client_security_protocol
                                       
                                                             
  oozie_server_config = get_properties2(cluster=cm_cluster_name, 
                                       config_type=CONFIG_TYPE_MAP['oozie'],
                                       accessor=ambari_accessor)
  #print "\nOOZIE_SERVER:\n", oozie_server_config
  oozie_url = oozie_server_config.get(CONFIG_PROPERTY_MAP['oozie_base_url'])
  CONFIG_KEY_VALUE_MAP['OOZIE_URL'] = oozie_url 

  
    
  if cm_tls_enabled.lower() == 'false':
    api = Ambari(cm_fqhn, port=cm_port, username=cm_user_name, password=cm_user_password, validate_ssl=False)
  else:
    api = ApiResource(cm_fqhn, port=cm_port, username=cm_user_name, password=cm_user_password, validate_ssl=True)
    
    
  # Get a list of all clusters
  cdh_cluster = None
  
  for c in api.clusters():
     if c.cluster_name == cm_cluster_name:
       print '\nCluster:', c.cluster_name
       cdh_cluster = c
       for x in cdh_cluster.hosts():
         HOST_MAP[x.host_name] =  x.host_name
       print '\nHost Name Mapping:'
       print HOST_MAP
       print '\nServices:'
       for x in cdh_cluster.services():
         print x.service_name
       #for x in cdh_cluster.configurations(): 
       #  print x.type
            
       
       #ZooKeeper
       zk_hosts = []
       zk_service  = cdh_cluster.services(SERVICE_NAME_MAP['zookeeper'])
       #print zk_service
       zk_server_cmps = zk_service.components(SERVICE_COMPONENT_NAME_MAP['zookeeper_server'])
       #print zk_server_cmps
       for x in zk_server_cmps.host_components:
         zk_hosts.append(x.host_name)
       #print 'ZOOKEEPER HOSTS:', zk_hosts
       if len(zk_hosts) > 0:
         CONFIG_KEY_VALUE_MAP['ZOOKEEPER_QUORUM'] = ' '.join(zk_hosts)
     
       #HDFS
       hdfs_nn_hosts = []
       hdfs_service  = cdh_cluster.services(SERVICE_NAME_MAP['hdfs'])
       hdfs_nn_cmps = hdfs_service.components(SERVICE_COMPONENT_NAME_MAP['namenode'])
       for x in hdfs_nn_cmps.host_components:
         hdfs_nn_hosts.append(x.host_name)
       
       
       #YARN RM
       yarn_rm_hosts = []
       yarn_service  = cdh_cluster.services(SERVICE_NAME_MAP['yarn'])
       yarn_rm_cmps = yarn_service.components(SERVICE_COMPONENT_NAME_MAP['resourcemanager'])
       for x in yarn_rm_cmps.host_components:
         yarn_rm_hosts.append(x.host_name)
       #print yarn_rm_hosts
    
    
       #OOZIE
       oozie_hosts = []
       oozie_service  = cdh_cluster.services(SERVICE_NAME_MAP['oozie'])
       oozie_server_cmps = oozie_service.components(SERVICE_COMPONENT_NAME_MAP['oozie_server'])
       for x in oozie_server_cmps.host_components:
         oozie_hosts.append(x.host_name)
       #print oozie_hosts
       
       #HBASE REST SERVER not managed by Ambari
       hbase_service  = cdh_cluster.services(SERVICE_NAME_MAP['hbase'])
       
       #KAFKA
       kafka_broker_hosts = []
       kafka_service  = cdh_cluster.services(SERVICE_NAME_MAP['kafka'])
       kafka_broker_cmps = kafka_service.components(SERVICE_COMPONENT_NAME_MAP['kafka_broker'])
       for x in kafka_broker_cmps.host_components:
         kafka_broker_hosts.append(x.host_name)
       if len(kafka_broker_hosts) > 0:
         CONFIG_KEY_VALUE_MAP['KAFKA_BROKER'] = ' '.join(kafka_broker_hosts)
       #print kafka_broker_hosts
    
       
   
    
        
       # Print all
       print '\nOUTPUT:\n', CONFIG_KEY_VALUE_MAP 
        
        
            
            
            
       
 

        

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='get configuration from Ambari Server API')
 
  parser.add_argument('--cm_fqhn', required=True,
                        help='Ambari Server FQHN')
  parser.add_argument('--cm_port', required=True,
                        help='Ambari Server Port')
  parser.add_argument('--cm_user_name', required=True,
                        help='Ambari Server User Name')
  parser.add_argument('--cm_user_password', required=True,
                        help='Ambari Server User Password')
  parser.add_argument('--cm_cluster_name', required=True,
                        help='Ambari Server Cluster Name')
  parser.add_argument('--cm_tls_enabled', required=True,
                        help='Ambari Server TLS enabled')
  
  args = parser.parse_args()
  main(cm_fqhn = args.cm_fqhn, 
       cm_port = args.cm_port,
       cm_user_name = args.cm_user_name, 
       cm_user_password = args.cm_user_password,
       cm_cluster_name = args.cm_cluster_name,
       cm_tls_enabled = args.cm_tls_enabled)