#!/usr/bin/env python
# -.- coding: utf-8 -.-

"""
WhoYeah(虎爺) - a grep like string finder in Python

*inspired:*
  - grep-ack - a perl grep-like
  - grin from http://pypi.python.org/pypi/grin for is_binary()

*TODO*
  - speed up, grep and ack-grep is faster
  - find in type (file extension, c, h, mk)
  - good ASCII icon

*FURTURE*
  - regular expression
  - export to file/HTML
  - case insensative

*CHANGELOG*
-----------
whoyeah.py-2.0, 2009-11-18
  * refactor and change project name
  * solve bugs: 
    - str.find('egg') >= 0
    - ignore dirs
  * add
    - ignore case
    - command parse options
    - multiple match in one line
mfind-1.0a, 2009-08-28
  * clear colorful() when is not 'TERM' environment
mfind-1.0,2009-05-05
  * done basic find
""" 

# for file open
from __future__ import with_statement # This isn't required in Python 2.6
import sys, os, string, re


### config ###
# set exclude files and dirs
IGNORE_FILES = ('TAGS', 'tags') #GLOBAL... 
IGNORE_DIRS = ('.git', '.svn')

TEXTCHARS = ''.join(map(chr, [7,8,9,10,12,13,27] + range(0x20, 0x100)))
ALLBYTES = ''.join(map(chr, range(256)))

# main 
def main(str_pattern, target_dir):
    num_files = 0
    num_match_files = 0
    num_matches = 0

    for path, dirs, files in os.walk(target_dir, topdown=True):
        for f in files:
            found = 0
            ignore = False
            # if path have ignore directorys, skip to next
            for dirt in IGNORE_DIRS:
                if path.find(dirt) > 0: 
                    ignore = True
                    break
            if not ignore and os.path.isfile(os.path.join(path, f)):
                found = find_in_file(f, path, str_pattern)
                if found > 0 :
                    num_match_files += 1
                num_files += 1
                num_matches += found

    print 'Summary:'
    print '  match', set_color(num_matches, 94), 'times, in', set_color(num_match_files, 94), 'files.'
    print '  total find', set_color(num_files, 94), 'files'


def find_in_file(f, path, str_pattern):
    full_path = os.path.join(path, f)
    re_flag = False
    found = 0
    ln = 0 # line number
                
    with open(full_path) as fopen:
        if is_binary(full_path) != 1 and f not in IGNORE_FILES:
            found = 0
            # find in each line
            for line in fopen:
                match = []
                ln += 1
                if options.ignore_case:
                    re_flag = re.IGNORECASE
                for m in re.finditer(str_pattern, str(line), re_flag):
                    match.append(m.group(0))
                if len(match) > 0:
                    if found == 0:
                        print set_color(full_path, 91)
                    for keyword in match:
                        line = replace_by_color(line, keyword, 95)
                        found += 1
                    print set_color(ln, 93) + ': ' + line[:-1]

        return found


def replace_by_color(string, keyword, color_code):
    return string.replace(str(keyword), set_color(str(keyword),95) )


def set_color(keyword, color_code):
    if os.getenv('TERM',None) in ['rxvt','xterm']:
        #return keyword.replace(str(keyword), '\033[0;'+str(color_code)+'m'+str(keyword)+'\033[m')
        return '\033[0;' + str(color_code) + 'm' + str(keyword) + '\033[m'
    else:
        return str(keyword)

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
    # parse options
    from optparse import OptionParser
    usage = "usage: %prog [options] PATTERN"
    parser = OptionParser(usage=usage)
    parser.add_option("-i", "--ignore_case",
                      action='store_true', dest='ignore_case', default=False,
                      help='ignore case sensitive')
    parser.add_option('-t', '--target', dest='target_dir', default='.',
                      help='set search target', metavar='TARGET')    
    (options, args) = parser.parse_args()

    if not args:
        parser.print_help()
    else:
        str_pattern = args[0]
        main(str_pattern, options.target_dir)
