# 2018_CapstoneProject_BigData_Issac

* * *

## 자동 클러스터 환경 구축 스크립트

빅 데이터 시스템을 구현하기 위해서는 분산 컴퓨팅을 위한 Cluster를 필요로 한다.
클러스터 관리 도구 중 Ambari를 설치하기 위하여 필요한 클러스터 환경을 자동으로 구성해주는 Shell Script 파일이다.
컴퓨터는 AWS EC-2를 활용하였다.

환경은 아래의 서버들로 구성이 되어 있으며, Data Node는 최소 3개를 필요로 한다.
*Ambari Server
*Name Node
*Data Node

### 사용 방법
Ambari Server / Node (4EA) 2개로 나누어 설명한다.

1. Ambari Server 및 모든 Node에 현재 repo를 다운받는다.
2. 파일에 실행 권한을 부여한다. (chmod u+x)
3. 모든 Node에서 NodeSetting.sh를 실행
4. Ambari Server에서 AbrSetting.sh를 실행
	- 인자로 Node의 IP를 입력받는다.
	- ex) ./AbrSetup.sh 172.31.25.201 172.31.18.118 172.31.21.118 172.31.27.94
	- 앞에서부터 NameNode / DataNode 1~3을 의미한다.
  

### 설정 내역
##### [Node]
1. 비밀번호 변경
	- 기본 비밀번호는 1111
	- 변경 희망시 AbrSetting.sh / NodeSetting.sh 파일의 PASSWORD 변수값 수정
2. 패스워드 접속 허용 (/etc/ssh/sshd_config)
3. ssh 서버 재구동

##### [Ambari Server]
1. 비밀번호 변경
2. Host Name 변경
3. Host Table 추가
4. ntp 설치, umask 변경
5. Selinux Disable
6. 키 생성
7. Node에 키 전송 및 동일한 세팅 진행
