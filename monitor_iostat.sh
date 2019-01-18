#!/bin/bash

# Monitor disk IO utility.
#
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-18

if ! which iostat &> /dev/null
then
    yum install -y sysstat
fi

if ! which iotop &> /dev/null
then
    yum install -y iotop
fi

logdir=/tmp/iolog
[ $logdir ] || mkdir $logdir

date_stamp=`date +%F`

# get the sum of %util for a single device and compute an average
function get_io() {
    dev=$1
    iostat -dx 1 5 > $logdir/iostat_${dev}.log
    sum=0
    for util in $(grep "^$dev" $logdir/iostat.log | awk '{print $NF}' | cut -d. -f1)
    do
        sum=$[$sum+$util]
    done
    echo $[$sum/5]
}

while true
do
    # iterate all devices
    for dev in $(iostat -dx | egrep -v '^$|Device:|CPU\)' | awk '{print $1}')
    do
        io=$(get_io $dev)
        if [ $io -ge 80 ]
        then
            date >> $logdir/$date_stamp
            cat $logdir/iostat_${dev}.log >> $logdir/$date_stamp
            iotop -obn2 >> $logdir/$date_stamp
            echo -e "###################################\n" >> $logdir/$date_stamp
        fi
    done
    sleep 60
done

