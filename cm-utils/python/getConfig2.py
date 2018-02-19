#!/usr/bin/python
# Get a handle to the API client
import ssl
import sys
import pprint
import argparse
from cm_api.api_client import ApiResource, ApiException
from cm_api.endpoints.services import ApiService, ApiServiceSetupInfo





def main(cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name): 
  #print cm_fqhn, cm_user_name, cm_user_password, cm_cluster_name
  api = ApiResource(server_host=cm_fqhn, username=cm_user_name, password=cm_user_password)  
  
  # Get a list of all clusters
  cdh_cluster = None
  host_id2name_map = {}
  host_name2id_map = {}
  
  for c in api.get_all_clusters():
    if c.name == cm_cluster_name:
      print '\nCluster:', c
      cdh_cluster = c
      for x in cdh_cluster.list_hosts():
        host_name2id_map[api.get_host(x.hostId).hostname] =  x.hostId
        host_id2name_map[x.hostId] = api.get_host(x.hostId).hostname 
      print '\nHostName to HostId Mapping:'
      for x in host_name2id_map:
        print  x, host_name2id_map[x]
      print '\nHostId to HostName Mapping:'
      for x in host_id2name_map:
        print  x, host_id2name_map[x]
      print '\nServices:'
      for x in cdh_cluster.get_all_services():
        print x.type


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
