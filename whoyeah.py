#!/usr/bin/env python
# -.- coding: utf-8 -.-

"""
WhoYeah(虎爺) - a grep like string finder in Python
(bad icon)
                  ...
        . ........   ..
        ..            ..
       .. ..         .. ..
     ..    ..     ...   ..
     .   ... .. ..    ....
     .   ....     ... .
     ..       .   .......
      .      ... . ..   .
     ..   ......... .....
     ... ........ ...


inspired:
-----------------
  * grep-ack - a perl grep-like
  * grin from http://pypi.python.org/pypi/grin for is_binary()

TODO
  - speed up, grep and ack-grep is faster
  - find in type (file extension, c, h, mk)
  - good ASCII icon

FURTURE - maybe
  - regular expression
  - export to file/HTML
  - case insensative

CHANGELOG
whoyeah.py-2.0, 2009-11-16
 * refactor and change project name
 * solve bugs: 
   - str.find('egg') >= 0
   - ignore dirs
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
IGNORE_FILES = ('TAGS', 'tags') #GLOBAL... 
IGNORE_DIRS = ('.git', '.svn')

TEXTCHARS = ''.join(map(chr, [7,8,9,10,12,13,27] + range(0x20, 0x100)))
ALLBYTES = ''.join(map(chr, range(256)))

# main 
def main():
    target_dir = '.'
    find_files = 0
    sum_of_files = 0
    sum_of_occurs = 0
    if len(sys.argv) == 3:
        target_dir = str(sys.argv[2]) 

    for path, dirs, files in os.walk(target_dir, topdown=True):
        for f in files:
            # ignore the dirs we don't want to find
            ignore = False
            for dirt in IGNORE_DIRS:
                if path.find(dirt) > 0: 
                    ignore = True
                    break
            if not ignore:
                found = find_in_file(f, path)
                if found > 0 : sum_of_files += 1
                find_files += 1
                sum_of_occurs += found

    print 'Summary:'
    print colorful('  find in '+str(find_files)+' files', str(find_files),94)
    print colorful('  occurs in '+str(sum_of_files)+' files', str(sum_of_files), 94) + colorful(', '+str(sum_of_occurs)+' times.', str(sum_of_occurs), 94)


def find_in_file(f, path):
    full_path = os.path.join(path, f)
    found = 0
    ln = 0 # line number

    with open(full_path) as fopen:
        if is_binary(full_path) != 1 and fopen not in IGNORE_FILES:
            # find in each line
            for line in fopen:
                ln += 1
                if str(line).find(STR_PATTERN) >= 0:
                    if found == 0:
                        # print file name
                        print colorful(full_path, full_path, 100) 
                    found += 1
                    # print line number and string, YELLOW and PURPLE!
                    print colorful(str(ln), str(ln), 93) + ': ' + colorful(line[:-1], STR_PATTERN, 95)
        return found


def colorful(obeh, colorize, code):
    if os.getenv('TERM',None) in ['rxvt','xterm']:
        return obeh.replace(colorize, '\033[0;'+ str(code) +'m' + colorize + '\033[m')
    else:
        return obeh


def is_binary(filename):
    fopen = open(filename, 'rb')
    is_binary = _is_binary_file(fopen)
    fopen.close()
    return is_binary


def _is_binary_file(fopen):
    bytes = fopen.read(1024)
    return is_binary_string(bytes)


def is_binary_string(bytes):
    nontext = bytes.translate(ALLBYTES, TEXTCHARS)
    return bool(nontext)


if __name__ == '__main__':
    # usage
    if len(sys.argv) < 2:
        cmd = sys.argv[0].split('/')[-1]
        print 'WhoYeah string finder, by MooGoo'
        print 'Usage: ' + cmd + ' <STRING> [TARGET_DIR]'
        sys.exit(1)
    else:
        STR_PATTERN = str(sys.argv[1])
        main()
