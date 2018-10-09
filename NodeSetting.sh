#!/bin/bash

####NodeSetting.sh####

# 비밀번호 설정
PASSWORD=1111
echo $PASSWORD | sudo passwd --stdin root
echo $PASSWORD | sudo passwd --stdin ec2-user
echo "PASSWORD ${PASSWORD}로 변경 완료"

# password 켜기
sudo sed -i '65d' /etc/ssh/sshd_config
sudo sed -i '65i'"PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart