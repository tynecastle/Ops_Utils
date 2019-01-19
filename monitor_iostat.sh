#!/bin/bash

# Monitor disk IO utility and report those higher than 80%.
# It is suggested that run this script once a minute.
#
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-19

TODAY=$(date +%Y%m%d)
LOGDIR=/tmp/iologs
TODAYDIR=$LOGDIR/$TODAY

if ! which iostat &> /dev/null
then
    yum install -y sysstat
fi

if ! which iotop &> /dev/null
then
    yum install -y iotop
fi

DEVICES=$(iostat -dx | egrep -v '^$|Device:|CPU\)' | awk '{print $1}')

[ -d $TODAYDIR ] || mkdir -p $TODAYDIR

# collect IO extended statistics for all devices
CURRTIME=$(date +%H%M%S)
iostat -dx 1 5 > $TODAYDIR/iostat_${CURRTIME}.log

# get the sum of %util for a single device and compute an average
function get_io() {
    dev=$1
    sum=0
    for util in $(grep "^$dev" $TODAYDIR/iostat_${CURRTIME}.log | awk '{print $NF}' | cut -d. -f1)
    do
        sum=$[$sum+$util]
    done
    echo $[$sum/5]
}

# iterate all devices
for dev in $DEVICES
do
    io=$(get_io $dev)
    if [ $io -ge 80 ]
    then
        date >> $LOGDIR/highIO_${TODAY}.log
        echo -e "\nIO utility of $dev goes beyond 80%\n" >> $LOGDIR/highIO_${TODAY}.log
        cat $TODAYDIR/iostat_${CURRTIME}.log | grep $dev >> $LOGDIR/highIO_${TODAY}.log
        echo "" >> $LOGDIR/highIO_${TODAY}.log
        iotop -obn2 >> $LOGDIR/highIO_${TODAY}.log
        echo -e "\n##########################################\n" >> $LOGDIR/highIO_${TODAY}.log
    fi
done

