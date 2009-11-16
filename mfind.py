#!/usr/bin/env python

# mfind: MooGoo's Find
"""
DESIGN - a grep like finder cross OS
calling sequence: 
-----------------
  main: recursive os.walk in sub-dirs
  -> find_in_file: find pattern in files (ignore files, dirs and binary)

inspired:
-----------------
  * grep-ack - a perl grep-like
  * grin from http://pypi.python.org/pypi/grin for is_binary()

TODO - do this first
  - benchmark(grep, ack-grep)
  - speed up
  - find in type (file extension, c, h, mk)

FURTURE - expend it, if I have time
  - regular expression
  - sum found files
  - export to file/HTML
  - case insensative

CHANGELOG
mfind-1.0a, 2009-08-28
  * clear colorful() when is not 'TERM' environment
mfind-1.0,2009-05-05
  * done basic find

""" 

# for file open
from __future__ import with_statement # This isn't required in Python 2.6
import sys, os, string

### config ###
# set exclude files and dirs
exclude_files = ("mfind", "TAGS", "tags") #GLOBAL... 
exclude_dirs = (".git", ".svn")


TEXTCHARS = ''.join(map(chr, [7,8,9,10,12,13,27] + range(0x20, 0x100)))
ALLBYTES = ''.join(map(chr, range(256)))


if len(sys.argv) < 2:
  print "mfind, by MooGoo with Python"
  print "  Usage: mfind STRING [TARGET]"
  sys.exit(1)


# main 
def main():
  target_dir = "." # default path
  ignore = 0 # test for ignore dirs
  sum_file = 0
  if len(sys.argv) == 3:
    target_dir = str(sys.argv[2]) 
  for path, dirs, files in os.walk(target_dir, topdown=True):
    if os.path.basename(path) not in exclude_dirs:
      for fn in files:
        sum_file = find_in_file(fn, path, sum_file)
  print colorful("=> found in " + str(sum_file) + " files", str(sum_file), 31)


def find_in_file(fn, path, sum_file):
  pattern = str(sys.argv[1])
  fn_with_path = os.path.join(path,fn)
  found = 0 # check if found
  with open(fn_with_path) as f:
    if is_binary(fn_with_path) != 1 and fn not in exclude_files:
      ln = 0 # line number
      for line in f:
        ln += 1
        # see if match!!!
        if str(line).find(pattern) > 0:
          if found == 0: 
            sum_file += 1
            # print file name, GREEN!
            print colorful(fn_with_path, fn_with_path, 92) 
          # print line number and string, YELLOW and PURPLE!
          found += 1
          print colorful(str(ln), str(ln), 93)+":" + colorful(line[:-1], pattern, 95)
  return sum_file


def colorful(obeh, colorize, code):
  if os.getenv('TERM',None) in ['rxvt','xterm']:
    return obeh.replace(colorize, '\033[0;'+ str(code) +'m' + colorize + '\033[m')
  else:
    return obeh

def is_binary(filename):
  f = open(filename, 'rb')
  is_binary = _is_binary_file(f)
  f.close()
  return is_binary

def _is_binary_file(f):
   bytes = f.read(1024)
   return is_binary_string(bytes)


def is_binary_string(bytes):
  nontext = bytes.translate(ALLBYTES, TEXTCHARS)
  return bool(nontext)

if __name__ == '__main__':
   main()
