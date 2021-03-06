#! /bin/bash

# myhosts.cfg example:
# user,host,port

HOST_DEF_FILE="$HOME/Dropbox/myhosts.cfg"


echo "============"
echo " Host lists"
echo "============"
cat $HOST_DEF_FILE | awk -F',' '{print NR ") " $2 " (" $4 ") - " $1 "@" $2 ":" $3}'
echo "------------"

if [ -z $1 ];then
    read -p "choose hosts: " USER_SEL
else
    USER_SEL=$1
fi

LINE_NO=0
for line in `cat $HOST_DEF_FILE`;do
    LINE_NO=`expr $LINE_NO + 1`
    if [ $LINE_NO == $USER_SEL ];then
        CMD=`echo $line | awk -F',' '{print "ssh -p" $3 " " $1 "@" $2}'`
        echo "executing..."
        echo $CMD
        $CMD
    fi
done
