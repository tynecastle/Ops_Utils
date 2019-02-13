#!/bin/bash

# Install latest version for docker on CentOS7.x

# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-02-10

# disable firewall
systemctl stop firewalld

# disable SELinux
if [[ -z $(grep '^SELINUX=disabled' /etc/selinux/config) ]]
then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
fi

# uninstall old versions of docker if any
yum remove docker \
           docker-client \
           docker-client-latest \
           docker-common \
           docker-latest \
           docker-latest-logrotate \
           docker-logrotate \
           docker-engine
/bin/rm -r /var/lib/docker

# set up docker repository
yum install -y -q yum-utils device-mapper-persistent-data lvm2
for app in yum-utils device-mapper-persistent-data lvm2
do
    if [[ -z $(rpm -q $app) ]]
    then
        echo -e "\033[31mFailed to install $app. Please look into it! \033[0m"
        exit 2
    fi
done
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# install the latest version of docker-ce
yum install -y -q docker-ce
if [[ -z $(rpm -q docker-ce) ]]
then
    echo -e "\033[31mFailed to install docker! \033[0m"
else
    echo -e "\033[32mDocker is installed successfully\033[0m"
    systemctl start docker
    systemctl enable docker
    echo -e "\033[32mDocker is started\033[0m"
fi
