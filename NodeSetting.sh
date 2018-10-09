#!/bin/bash

####NodeSetting.sh####

# Password Setting
PASSWORD=1111
echo $PASSWORD | sudo passwd --stdin root
echo $PASSWORD | sudo passwd --stdin ec2-user
echo "PASSWORD Changed : ${PASSWORD}"

# Allow Password Access
sudo sed -i '65d' /etc/ssh/sshd_config
sudo sed -i '65i'"PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart

