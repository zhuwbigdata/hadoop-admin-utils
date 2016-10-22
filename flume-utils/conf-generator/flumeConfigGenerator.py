import sys
import json

def createDictoryFromJson(agent, js):
  type = js['TYPE']
  if type == 'agent':
    createAgent(agent, js)
  elif type == 'source':
    createSource(agent, js)

def createAgent(agent, js):
  agent['name']     = js['NAME']

  sources  =  js['SOURCES'].split()
  agent['sources'] = ()
  for source in sources:
    agent['source_details'].setdefault(source) 
  
  channels  =  js['CHANNELS'].split()
  agent['channels'] = ();
  for channel in channels:
    agent['channels'].setdefault(channel) 
  agent['sinks']    = js['SINKS'].split()

def createSource(agent, js):
  source = () 
  source['name']     = js['NAME']
  source['channels'] = js['CHANNELS'].split()
  source['interceptors']    = js['INTERCEPTORS'].split()
  source['others']    = js['OTHERS'].split('|')
  agent. 



def printAgent(agent):
  print agent['name']+'.sources = '+','.join(agent['sources'])
  print agent['name']+'.channels = '+','.join(agent['channels'])
  print agent['name']+'.sinks = '+','.join(agent['sinks'])




fname = sys.argv[1]
lines = [] 
for line in open(fname):
  line = line.strip()
  if not line.startswith("#"):
       lines.append(line.rstrip())
jsonlist = []
for line in lines:
  jsonlist.append(json.loads(line))
del lines[:]
agent = {}
for jsonitem in jsonlist:
  print json.dumps(jsonitem, indent=4, sort_keys=True)
  createDictoryFromJson(agent, jsonitem)
printAgent(agent)
