#!/bin/bash

####AutoSetting.sh#### $1 - IP / $2 - HostName

# Rename HostName
sudo hostnamectl set-hostname $2
sudo sed -i '2i'"HOSTNAME=$2.hd.hadoop.cau" /etc/sysconfig/network

# Add Host Table
sudo sed -i '2i'"$3" /etc/hosts

# Not Allow Password Access
sudo sed -i '65d' /etc/ssh/sshd_config
sudo sed -i '65i'"PasswordAuthentication no" /etc/ssh/sshd_config
sudo service sshd restart

# Default Node Setting
sudo yum -y install wget
sudo yum -y install ntp
umask 0022
sudo systemctl enable ntpd

# Selinux Disable
sudo sed -i '/SELINUX=enforcing/d' /etc/selinux/config
sudo sed -i '6i'"SELINUX=disabled" /etc/selinux/config

#
sudo yum-config-manager --enable rhui-REGION-rhel-server-optional
sudo yum -y install libtirpc-devel
 


