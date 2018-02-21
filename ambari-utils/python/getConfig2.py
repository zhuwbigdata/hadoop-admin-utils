#!/usr/bin/python
# Get a handle to the API client
import ssl
import sys
import pprint
import argparse
from cm_api.api_client import api_client

SERVICE_TYPE_MAP = {
  'zookeeper': 'ZOOKEEPER',
  'hdfs': 'HDFS',
  'hbase': 'HBASE',
  'yarn': 'YARN',
  'oozie': 'OOZIE',
  'hbase': 'HBASE',
  'kafka': 'KAFKA',
}

    
SERVICE_ROLE_TYPE_MAP = {
  'zookeeper_server': 'SERVER',
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
  'hdf_nn_ns': 'dfs_federation_namenode_nameservice',
  'hdf_nn_port': 'namenode_port',
  'yarn_rm_address':  'yarn_resourcemanager_addres',
  'oozie_http_port': 'oozie_http_port',
  'oozie_https_port':  'oozie_https_port',
  'oozie_use_ssl':  'oozie_use_ssl',
  'oozie_load_balancer': 'oozie_load_balancer',
  'hbase_rs_port': 'hbase_restserver_port',
  'hbase_rs_host': 'hbase_restserver_host',
  'kafka_client_security_protocol': 'security.inter.broker.protocol',
}


def ambariREST( restAPI ) :
    url = "http://"+AMBARI_DOMAIN+":"+AMBARI_PORT+restAPI
    r= requests.get(url, auth=(AMBARI_USER_ID, AMBARI_USER_PW))
    return(json.loads(r.text));

def rmREST( restAPI ) :
    url = "http://"+RM_DOMAIN+":"+RM_PORT+restAPI
    r=requests.get(url)
    return(json.loads(r.text));

def getClusterVersionAndName() :
    json_data = ambariREST("/api/v1/clusters")
    cname = json_data["items"][0]["Clusters"]["cluster_name"]
    cversion =json_data["items"][0]["Clusters"]["version"]
    return cname, cversion, json_data;

def getAmbariHosts() :
    restAPI = "/api/v1/hosts"
    json_data =  ambariREST(restAPI)
    return(json_data);
    
def getConfigGroups() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/config_groups"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getServiceConfigTypes() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/configurations"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getServiceActualConfigurations() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getStackVersions() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/stack_versions/"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getServices( SERVICE) :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/services/"+SERVICE
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getResourceManagerInfo() :
    restAPI = "/ws/v1/cluster/info"
    json_data =  rmREST(restAPI)
    return(json_data);

def getResourceManagerMetrics() :
    restAPI = "/ws/v1/cluster/metrics"
    json_data =  rmREST(restAPI)
    return(json_data);

def getRMschedulerInfo() :
    restAPI = "/ws/v1/cluster/scheduler"
    json_data =  rmREST(restAPI)
    return(json_data);

def getAppsSummary() :
    restAPI = "/ws/v1/cluster/apps"
    json_data =  rmREST(restAPI)
    return(json_data); 

def getAppsStatistics() :
    restAPI = "/ws/v1/cluster/appstatictics"
    json_data =  rmREST(restAPI)
    return(json_data); 
    
def getNodesSummary() :
    restAPI = "/ws/v1/cluster/nodes"
    json_data =  rmREST(restAPI)
    return(json_data); 


def main(cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name, cm_tls_enabled, cm_tls_cafile):
  #print  cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name, cm_tls_enabled, cm_tls_cafile 
  if cm_tls_enabled == 'false':
    api = ApiResource(server_host=cm_fqhn, username=cm_user_name, password=cm_user_password)
  else:
    context = ssl.create_default_context(cafile=cm_tls_cafile)
    api = ApiResource(server_host=cm_fqhn, username=cm_user_name, password=cm_user_password, use_tls=True, ssl_context=context)

  # Get a list of all clusters
  cdh_cluster = None

  for c in api.get_all_clusters():
    print c

        

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
  parser.add_argument('--cm_tls_enabled', required=True,
                        help='Cloudera Manager TLS enabled')
  parser.add_argument('--cm_tls_cafile', required=False,
                        help='Cloudera Manager TLS CA file location')
  args = parser.parse_args()
  main(cm_fqhn = args.cm_fqhn, 
       cm_user_name = args.cm_user_name, 
       cm_user_password = args.cm_user_password,
       cm_cluster_name = args.cm_cluster_name,
       cm_tls_enabled = args.cm_tls_enabled,
       cm_tls_cafile = args.cm_tls_cafile)
