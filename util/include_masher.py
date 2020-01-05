import sys
import argparse
import os.path

parser = argparse.ArgumentParser(description="Takes the input of `gcc -M` and converts it into a bzl file")
parser.add_argument("-i", "--input", default="stdin", help="name of the file to read from")
parser.add_argument("-o", "--output", default="stdout", help="name of the file to write to")
parser.add_argument("-n", "--name", help="name of the variable to write in the bzl file")
args = parser.parse_args()
name = args.name
outfile = None
infile = None
if args.input == "stdin":
    infile = sys.stdin
else:
    infile = open(args.input, 'r')

if args.output == "stdout":
    outfile = sys.stdout
else:
    outfile = open(args.output, 'w')
if name == None:
    name = outfile.split(".")[0]
contents = infile.read()
infile.close()

contents = contents.replace("\\\n ", "").replace("\n", "")
contents = contents[contents.index(":") + 2:]
contents = [os.path.normpath(c) for c in contents.split(" ") if c.startswith("glm")]

if args.name != None:
    outfile.write("{} = ".format(args.name))
outfile.write(str(sorted(set(contents))))
outfile.close()
