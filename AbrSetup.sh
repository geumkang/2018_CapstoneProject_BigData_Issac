#!/bin/bash

####AbrSetup.sh#### $1 - NameNode IP / $2~4 - DataNode IPs

HostName=("ambari" "namenode" "datanode1" "datanode2" "datanode3")
IP=($0 $1 $2 $3 $4)    #private IP

# hosttable IP 입력
currentIP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
hosttable="$currentIP ${HostName[0]}.hd.hadoop.cau ${HostName[0]}"
for (( i = 1 ; i <= $# ; i++ ));
do
hosttable+="\n${IP[$i]} ${HostName[$i]}.hd.hadoop.cau ${HostName[$i]}"
done

sudo yum -y install expect

# 비밀번호 설정
PASSWORD=1111
echo $PASSWORD | sudo passwd --stdin root
echo $PASSWORD | sudo passwd --stdin ec2-user
echo "PASSWORD ${PASSWORD}로 변경 완료"

# 호스트 네임 변경
sudo hostnamectl set-hostname ${HostName[0]}
sudo sed -i '2i'"HOSTNAME=${HostName[0]}.hd.hadoop.cau" /etc/sysconfig/network

# 호스트 테이블 추가
sudo sed -i '2i'"$hosttable" /etc/hosts

# 노드 기본 설정
sudo yum -y install wget
sudo yum -y install ntp
umask 0022
sudo systemctl enable ntpd

# selinux 해제
sudo sed -i '/SELINUX=enforcing/d' /etc/selinux/config
sudo sed -i '6i'"SELINUX=disabled" /etc/selinux/config

# 키 생성
ID_RSA=~/.ssh/id_rsa.pub
if [ ! -f $ID_RSA ]; then       #  id_rsa.pub 파일이 없을때만 ssh-keygen을 수행
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

# ssh로 키, 매크로 던지기
for (( i = 1 ; i <= $# ; i++ ));
do
expect -c "spawn ssh-copy-id -i $ID_RSA ec2-user@${IP[$i]}" \
-c "expect -re \"yes\"" \
-c "send \"yes\r\"" \
-c "expect -re \"password\"" \
-c "send \"$PASSWORD\r\"" \
-c "interact"
echo "key 전송 완료"
ssh ec2-user@${IP[$i]} 'bash -s' < AutoSetting.sh ${IP[$i]} ${HostName[$i]} $hosttable
done
