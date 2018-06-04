import json
import os

def listall(path):
    things = sorted([x for x in os.listdir(path) if x != ".contents.lua"])
    for i, thing in enumerate(things):
        if os.path.isdir(thing):
            things[i] = thing + "/"
    with open(os.path.join(path, ".contents.lua"), 'w') as f:
        f.write('return {' + ','.join([json.dumps(x) for x in things]) + '}') 
    for i, thing in enumerate(things):
        if os.path.isdir(thing):
            listall(os.path.join(path, thing))

listall(".")
