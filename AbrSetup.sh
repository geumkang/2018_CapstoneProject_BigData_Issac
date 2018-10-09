#!/bin/bash

####AbrSetup.sh#### $1 - NameNode IP / $2~4 - DataNode IPs

HostName=("ambari" "namenode" "datanode1" "datanode2" "datanode3")
IP=($0 $1 $2 $3 $4)    #private IP

# hosttable IP �Է�
currentIP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
hosttable="$currentIP ${HostName[0]}.hd.hadoop.cau ${HostName[0]}"
for (( i = 1 ; i <= $# ; i++ ));
do
hosttable+="\n${IP[$i]} ${HostName[$i]}.hd.hadoop.cau ${HostName[$i]}"
done

sudo yum -y install expect

# ��й�ȣ ����
PASSWORD=1111
echo $PASSWORD | sudo passwd --stdin root
echo $PASSWORD | sudo passwd --stdin ec2-user
echo "PASSWORD ${PASSWORD}�� ���� �Ϸ�"

# ȣ��Ʈ ���� ����
sudo hostnamectl set-hostname ${HostName[0]}
sudo sed -i '2i'"HOSTNAME=${HostName[0]}.hd.hadoop.cau" /etc/sysconfig/network

# ȣ��Ʈ ���̺� �߰�
sudo sed -i '2i'"$hosttable" /etc/hosts

# ��� �⺻ ����
sudo yum -y install wget
sudo yum -y install ntp
umask 0022
sudo systemctl enable ntpd

# selinux ����
sudo sed -i '/SELINUX=enforcing/d' /etc/selinux/config
sudo sed -i '6i'"SELINUX=disabled" /etc/selinux/config

# Ű ����
ID_RSA=~/.ssh/id_rsa.pub
if [ ! -f $ID_RSA ]; then       #  id_rsa.pub ������ �������� ssh-keygen�� ����
expect -c "spawn ssh-keygen" \
                   -c "expect -re \":\"" \
                   -c "send \"\r\"" \
                   -c "expect -re \":\"" \
                   -c "send \"\r\"" \
                   -c "expect -re \":\"" \
                   -c "send \"\r\"" \
                   -c "puts \" \n * ssh-keygen success!!#3 *\"" \
                   -c "interact"
fi

# ssh�� Ű, ��ũ�� ������
for (( i = 1 ; i <= $# ; i++ ));
do
expect -c "spawn ssh-copy-id -i $ID_RSA ec2-user@${IP[$i]}" \
-c "expect -re \"yes\"" \
-c "send \"yes\r\"" \
-c "expect -re \"password\"" \
-c "send \"$PASSWORD\r\"" \
-c "interact"
echo "key ���� �Ϸ�"
ssh ec2-user@${IP[$i]} 'bash -s' < AutoSetting.sh ${IP[$i]} ${HostName[$i]} $hosttable
done
