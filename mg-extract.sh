#!/bin/bash
zip_file=$1
target_dir=$2

ext=${zip_file##*.}

if [ $ext=="bz2" ]; then
  echo "bbb"
elif [ $ext == "tgz" ]; then
  echo "ggg"
fi

#mkdir $target_dir
#mv $zip_file $target_dir
#cd $target_dir
#tar/unzip -zxvf/-x $zip_file

