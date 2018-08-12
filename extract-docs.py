import os
import re

classes = {}

p = re.compile("\-\-\[\[\-\-((?:[^\]]*(?:\][^\]])?)*)\]\]\n(function ([^\(]*)\([^\)]*\))")
bd = re.compile("\s*return")
def matcher(obj):
    m = obj.group(0)
    doc = (obj.group(1))
    fname = obj.group(3).strip().split(".")
    fobj = ""
    if len(fname) > 1:
        fobj = ".".join(fname[:-1])
    fname = fname[-1]
    if not (fobj in classes):
        classes[fobj] = True
        print("/** @class", fobj, "*/")
    print("/**")
    print(doc)
    print("   @relates", fobj)
    print("   @name", fname)
    print("   @fn", obj.group(2))
    print("*/")
    return "tst"
def listall(path):
    things = sorted([x for x in os.listdir(path) if x != ".contents.lua" and x.endswith(".lua") and x.count(".") == 1 and os.path.isfile(os.path.join(path, x))])
    for name in things:
        full = os.path.join(path, name)
        contents = ""
        with open(full, "r") as f:
            contents = f.read()
        if bd.match(contents):
            #print("BAD")
            continue
        p.sub(matcher, contents)
    for thing in os.listdir(path):
        name = os.path.join(path, thing)
        if os.path.isdir(name):
            listall(name)

            

listall("resources")
