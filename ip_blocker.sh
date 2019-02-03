#!/bin/bash

# Block IPs that have large amount of visits in short term

# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-02-03

d1=$(date -d "-1 min" +%F)
t1=$(date -d "-1 min" +%H:%M)
lastMin=${d1}"T"${t1}
logFile=/data/joblog/httpd/access_log

function block_ip() {
    egrep "$lastMin:[0-5]+" $logFile > /tmp/last_min.log
    # record those IPs that have more than 100 visits during last minute as "bad IPs"
    awk '{print $1}' /tmp/last_min.log | sort -n | uniq -c | sort -n | awk '$1>100{print $2}' > /tmp/bad_ip.list
    # the total number of bad IPs
    n=$(wc -l /tmp/bad_ip.list | awk '{print $1}')
    # block the bad IPs when the list is not empty
    if [ $n -ne 0 ]
    then
        for ip in $(cat /tmp/bad_ip.list)
        do
            iptables -I INPUT -s $ip -j REJECT
        done
        # record the blocked IPs in a separate file
        echo "$(date '+%F %H:%M:%S') The following IPs are blocked:" >> /tmp/block_ip.log
        cat /tmp/bad_ip.list >> /tmp/block_ip.log
        echo "" >> /tmp/block_ip.log
    fi
}

function unblock_ip() {
}

t=$(date +%M)

# invoke block_ip() every minute, and invoke unblock_ip() every 30 minutes
if [ $t == "00" ] || [ $t == "30" ]
then
    unblock_ip
    block_ip
else
    block_ip
fi
