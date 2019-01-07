#!/bin/bash

inventory='expect_inventory'
pw='123456789'

chmod +x expect_main.exp

cat $inventory | while read line
do
    ip=`echo $line | awk '{print $1}'`
    ./expect_main.exp $ip $pw
done
