#! /usr/bin/env python

#-------------------------
# thumb - 0.3
# make thumbnails
# moogoo, 2008-09-19
#-------------------------
"""
Features:
  - use PIL module
  - default target, don't input too much
  - no GUI, clean CLI
  - run on Windows, GNU/Linux (Ubuntu 8.04)
  - only support JPEG

TODO:
  - try Mac portable
  - support GIF, or more

Changes:
  - remove wx module and re-design from sika-0.2
"""

import os, os.path, sys
from PIL import Image

#setting
size_list = {'s': (240), 'm': (500), 'l': 1024}
target_file_prefix = "tn_"
if os.name == 'nt': target_dir_default = "c:\\turtle_thumb"
elif os.name =='posix': target_dir_default = os.path.expanduser('~/turtle_thumb')
else: target_dir_default = "."


def do_thumb(size, source):
  #set size
  if size == 's': tn_size = (size_list['s'], size_list['s'])
  elif size == 'm': tn_size = (size_list['m'], size_list['m'])
  elif size == 'l': tn_size = (size_list['l'], size_list['l'])
  else: tn_size = (int(size), int(size))

  if os.path.isdir(source): # if source is a directory
    print "make thumbnails with resolution: " + str(tn_size)      
    for path, dir, files in os.walk(source, topdown=False):
      total_files = len(files)        
      for name in files: 
        source = os.path.join(path, name)
        img_squeeze(tn_size, source)
  elif os.path.isfile(source): # if source is a file
    print "make thumbnail with resolution: " + str(tn_size)
    img_squeeze(tn_size, source)
  else:
    if os.path.exists(source) == 0:
      print "source file or directory not exist!"


def img_squeeze(size, source):  
  tn_source = target_file_prefix + os.path.split(source)[1]    
  target = os.path.join(target_dir_default, tn_source)
  if os.path.exists(target_dir_default) == 0:
    print "create target directory... " + target_dir_default
    os.mkdir(target_dir_default)
  #squeeze!
  im = Image.open(source)            
  im.thumbnail(size, Image.ANTIALIAS)
  im.save(target, "JPEG")
  #print results
  fsize = round(os.path.getsize(target) / 100) / 10
  print target + " - " + str(fsize) + " kB"


if __name__ == '__main__':
  if len(sys.argv) < 3:
    print "Usage: thumb.py size source"
    print "  size: s(240), m(500), l(1024)"
    print "  source: file or dirs"
  else:
    do_thumb(sys.argv[1], sys.argv[2])
