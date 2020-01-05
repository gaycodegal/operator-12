import sys
import argparse
import os.path

parser = argparse.ArgumentParser(description="takes the input of `gcc -M` and converts it into a bzl file")
parser.add_argument("-i", "--input", default="stdin")
parser.add_argument("-o", "--output", default="stdout")
parser.add_argument("-n", "--name")
args = parser.parse_args()

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
    
contents = infile.read()
infile.close()

contents = contents.replace("\\\n ", "").replace("\n", "")
contents = contents[contents.index(":") + 2:]
contents = [os.path.normpath(c) for c in contents.split(" ") if c.startswith("glm")]

if args.name != None:
    outfile.write("{} = ".format(args.name))
outfile.write(str(sorted(set(contents))))
outfile.close()
