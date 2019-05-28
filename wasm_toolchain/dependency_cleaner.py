"""Script to remove absolute paths from dependency ".d" files generated
by emcc as these break bazel.

Script should be run after emcc is run with the same args as were passed to
emcc. We only care about the "-o" value but do not fail due to extra args.

Theoretically we should convert absolute paths to paths relative to the
project's file system, but bazel's approach is to pretend that the
project is in its own little universe and a fixer script knowing the
absolute path of the project breaks that paradigm."""
from __future__ import print_function, division
import re
from argparse import ArgumentParser
from sys import argv, exit
import os.path

# We're parsing the input from the emcc command looking for
# the name of the output file generated. We only care about the "-o" argument
# because that stores the name, so we ignore all other options / flags.
parser = ArgumentParser(description=__doc__)
parser.add_argument(
    "-o",
    nargs=1,
    help="The same output name as passed to emcc")
args, unknown = parser.parse_known_args(argv)

# If we didn't find that argument we don't need to clean
if args.o is None:
    exit(0)
name = args.o[0]

# We only care about object ".o" files because those are the ones with
# associated dependency ".d" files.
if not name.endswith(".o"):
    exit(0)

# We only have to fix a file if it exists
name = name[:-2] + ".d"
if not os.path.isfile(name):
    exit(0)

# Pattern matches absolute paths (lines generally starting with "/")
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
