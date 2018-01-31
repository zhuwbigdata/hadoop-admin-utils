'''
Created on Oct 23, 2016

@author: waynezhu
'''
import sys
import json
from tkFont import names


def getNamesFromListOfDicts(dlist):
    names = []
    for d in dlist:
        names.append(d['NAME'])
    return names

def printInterceptor(agent_name, source_name, interceptor):
    name = interceptor['NAME']
    print agent_name + '.sources.' + source_name + '.interceptors.' + name + '.type = ' + interceptor['TYPE']
    others = interceptor['OTHERS']
    for key in others.keys():
        print agent_name + '.sources.' + source_name + '.interceptors.' + name + '.' + key + ' = ' + others.get(key)
    
def printSource(agent_name, source):
    source_name = source['NAME']
    print '# Define / Configure source : ' + source_name
    print agent_name + '.sources.' + source_name + '.type = ' + source['TYPE']
    others = source['OTHERS']
    for key in others.keys():
        print agent_name + '.sources.' + source_name + '.' + key + ' = ' + others.get(key)
    print agent_name + '.sources.' + source_name + '.channels = ' + source['CHANNELS']
    
    print '# Define interceptors for source : ' + source_name
    interceptors = source['INTERCEPTORS']
    print agent_name + '.sources.' + source_name + '.interceptors = ' + ' '.join(getNamesFromListOfDicts(interceptors))
    for interceptor in interceptors:
        printInterceptor(agent_name, source_name, interceptor)
        
    print '# Configure multiplexing/selector (optional)'
    if 'SELECTOR' in source:
        selector = source['SELECTOR']
        print agent_name + '.sources.' + source_name + '.selector = ' + selector['TYPE']
        others = selector['OTHERS']
        for key in others.keys():
            print agent_name + '.sources.' + source_name + '.selector.' + key + ' = ' + others.get(key)
    
    
def printSink(agent_name, sink):
    sink_name = sink['NAME']
    print '# Define / Configure sink : ' + sink_name
    print agent_name + '.sinks.' + sink_name + '.type = ' + sink['TYPE']
    others = sink['OTHERS']    
    for key in others.keys():
        print agent_name + '.sinks.' + sink_name + '.' + key + ' = ' + others.get(key)   
        
def printChannel(agent_name, channel):
    channel_name = channel['NAME']
    print '# Define / Configure channel : ' + channel_name
    print agent_name + '.channels.' + channel_name + '.type = ' + channel['TYPE']
    others = channel['OTHERS']    
    for key in others.keys():
        print agent_name + '.channels.' + channel_name + '.' + key + ' = ' + others.get(key)     
  
def printAgent(agent):
    agent_name = agent['NAME']
    print '#Initialize variables for source, channels, and sinks'
    sources = agent['SOURCES']
    channels = agent['CHANNELS']
    sinks = agent['SINKS']
    print agent_name + '.sources = ' + ' '.join(getNamesFromListOfDicts(sources))
    print agent_name + '.channels = ' + ' '.join(getNamesFromListOfDicts(channels))
    print agent_name + '.sinks = ' + ' '.join(getNamesFromListOfDicts(sinks))
    
    for source in sources:
        printSource(agent_name, source)
        
    for sink in sinks:
        printSink(agent_name, sink)
        
    for channel in channels:
        printChannel(agent_name, channel)
        
#fname = sys.argv[1]
fname= 'conf-agent-flume.json'
f = open(fname)
jst = f.read()             
f.close()
jsd = json.loads(jst)
#print json.dumps(jsd, indent=4)
printAgent(jsd)










