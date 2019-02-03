#!/bin/bash

# Block IPs that have large amount of visits in short term

# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-02-02

t1=$(date -d "-1 min" +%H:%M:%S)
log=/data/joblog/httpd/access_log

function block_ip() {
}

function unblock_ip() {
}

if [ $t == "00" ] || [ $t == "30" ]
then
    unblock_ip
    block_ip
else
    block_ip
fi
