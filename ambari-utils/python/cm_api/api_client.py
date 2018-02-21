# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import logging
try:
  import json
except ImportError:
  import simplejson as json

from cm_api.http_client import HttpClient, RestException
from cm_api.endpoints import clusters
from cm_api.endpoints import types
from cm_api.resource import Resource

__docformat__ = "epytext"

LOG = logging.getLogger(__name__)

API_AUTH_REALM = "Apache Ambari"
API_CURRENT_VERSION = 1

class ApiException(RestException):
  """
  Any error result from the API is converted into this exception type.
  This handles errors from the HTTP level as well as the API level.
  """
  def __init__(self, error):
    # The parent class will set up _code and _message
    RestException.__init__(self, error)
    try:
      # See if the body is json
      json_body = json.loads(self._message)
      self._message = json_body['message']
    except (ValueError, KeyError):
      pass    # Ignore json parsing error


class ApiResource(Resource):
  """
  Resource object that provides methods for managing the top-level API resources.
  """

  def __init__(self, server_host, server_port=None,
               username="admin", password="admin",
               use_tls=False, version=API_CURRENT_VERSION,
               ssl_context=None):
    """
    Creates a Resource object that provides API endpoints.

    @param server_host: The hostname of the Cloudera Manager server.
    @param server_port: The port of the server. Defaults to 7180 (http) or
      7183 (https).
    @param username: Login name.
    @param password: Login password.
    @param use_tls: Whether to use tls (https).
    @param version: API version.
    @param ssl_context: A custom SSL context to use for HTTPS (Python 2.7.9+)
    @return: Resource object referring to the root.
    """
    self._version = version
    protocol = use_tls and "https" or "http"
    if server_port is None:
      server_port = use_tls and 7183 or 7180
    base_url = "%s://%s:%s/api/v%s" % \
        (protocol, server_host, server_port, version)

    client = HttpClient(base_url, exc_class=ApiException,
                        ssl_context=ssl_context)
    client.set_basic_auth(username, password, API_AUTH_REALM)
    client.set_headers( { "Content-Type" : "application/json" } )
    Resource.__init__(self, client)

  @property
  def version(self):
    """
    Returns the API version (integer) being used.
    """
    return self._version

  def get_all_clusters(self, view = None):
    """
    Retrieve a list of all clusters.
    @param view: View to materialize ('full' or 'summary').
    @return: A list of ApiCluster objects.
    """
    return clusters.get_all_clusters(self, view)

  def get_cluster(self, name):
    """
    Look up a cluster by name.

    @param name: Cluster name.
    @return: An ApiCluster object.
    """
    return clusters.get_cluster(self, name)


def get_root_resource(server_host, server_port=None,
                      username="admin", password="admin",
                      use_tls=False, version=API_CURRENT_VERSION):
  """
  See ApiResource.
  """
  return ApiResource(server_host, server_port, username, password, use_tls,
      version)
