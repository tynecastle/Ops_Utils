#!/bin/bash

# Create 100 users in batch, namely 'user00' to 'user99'.
# All of the users should belong to a group named 'users'.
# Generate random password of 12-bit length for each user.
# The passwords should not contain any special characters.
# Record the user name and password pairs in a text file.

# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-04

## record the user name and password pairs in this text file
text_file=/data/user_pass

## make sure 'expect' is installed, which provides 'mkpasswd'
if ! which mkpasswd &>/dev/null
then
    echo -n "Command 'mkpasswd' is not found. Installing expect ... "
    yum -q -y install expect
    if [ $? -eq 0 ]
    then
        echo "done"
    else
        echo -e "\033[31m\nFailed to install expect! \033[0m"
        echo "No user is created."
        exit 2
    fi
fi

## create group named 'users' in case it doesn't exist
group_name=$(grep 'users' /etc/group | cut -d: -f1)
if [[ -z $group_name ]]
then
    groupadd users
    echo "users group is created"
else
    echo "users group exists already"
fi

[ -f $text_file ] && /bin/rm $text_file

## create users
for n in `seq -w 0 99`
do
    useradd -g users user${n}
    pass=$(mkpasswd -l 12 -s 0)
    echo $pass | passwd --stdin user${n}
    echo -e "user${n}\t${pass}" >> $text_file
    echo -e "\033[32muser${n} is created successfully\033[0m"
done

