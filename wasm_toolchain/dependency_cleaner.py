from __future__ import print_function, division
import re
from argparse import ArgumentParser
from sys import argv, exit
import os.path
parser = ArgumentParser()
parser.add_argument("-o", nargs=1)
args, unknown = parser.parse_known_args(argv)
if args.o is None:
    exit(0)
name = args.o[0]
if not name.endswith(".o"):
    exit(0)
name = name[:-2] + ".d"
if not os.path.isfile(name):
    exit(0)

regex = re.compile("^\s*/")
contents = ""
valid_lines = lambda x: not regex.match(x)

# filter out absolute paths
# possibly misses short absolute paths of the form:
# relative_path /absolute_path
# could be avoided but i'm lazy.
with open(name, "r") as f:
    lines = "".join(filter(valid_lines, f.readlines()))

# write the valid ones to disk
with open(name, "w") as f:
    f.write(lines)
