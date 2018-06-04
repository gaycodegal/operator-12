import sys
import json
gname = json.loads(sys.stdin.readline())
def createMethod(name, argnames, argtypes, luatypes, nret):
    return """- %s(%s)
    - returns %i""" % (name, ",".join(argnames), nret)

v = []
i = 1
for line in sys.stdin:
    i += 1
    try:
        v.append(json.loads(line))
        if len(v) == 5:
            print(createMethod(*v))
            v = []
    except Exception as e:
        print("error at line:", i)
        print(e)
        sys.exit(1)

