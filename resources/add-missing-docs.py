import os
import re

p = re.compile("\n\nfunction [^\(]*\([^\)]*\)")
bd = re.compile("\s*return")
def matcher(obj):
    m = obj.group(0)
    args = m[m.index("(") + 1:m.index(")")]
    args = ([x.strip() for x in args.split(",") if len(x.strip()) > 0])
    docstr = "--[[\ndesc.\n" + "".join(["\n@param " + arg + " " for arg in args]) + ("\n" if len(args) > 0 else "") + "\n@return\n]]"
    return "\n\n" + docstr + m[1:]
def listall(path):
    things = sorted([x for x in os.listdir(path) if x != ".contents.lua" and x.endswith(".lua") and x.count(".") == 1 and os.path.isfile(os.path.join(path, x))])
    for name in things:
        full = os.path.join(path, name)
        contents = ""
        with open(full, "r") as f:
            contents = f.read()
        if bd.match(contents):
            print("BAD")
            continue
        try:
            n = p.sub(matcher, contents)
            with open(full, "w") as f:
                f.write(print(n))
        except e:
            pass
        
    for thing in os.listdir(path):
        if os.path.isdir(thing):
            listall(os.path.join(path, thing))

            

listall(".")
