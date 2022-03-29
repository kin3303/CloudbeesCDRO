 
### Cloudbees CD 서버 설치 및 설정

- Cloudbees CD 서버 설치 및 설정을 아래와 같이 진행한다.

#### Step 1 > 소스 다운로드

```console

   $ git clone https://github.com/kin3303/CloudbeesCDRO
   $ cd CloudbeesCDRO
   $ git checkout master
```


#### Step 2 > CD, Web, Repo 서버 설치

```console
   $ sudo su
   $ cd data/server
   $ chmod 777 install_cd_server.sh
   $ ./install_cd_server.sh
   
   # SampleProject 설치를 원하는 경우는 아래 커맨드도 같이 실행
   $ chmod 777 import_sample_project.sh
   $ ./import_sample_project.sh
```

#### Step 3 > CD 서버에 DB 설정

- Administration > Database Configuration 으로 이동 후 MySQL DB 설정

```
  Database Type : Mysql
  Database Name : ecdb
  Host name : <DB_SERVER_IP>
  Port : 3306
  Username : ecuser
  Password : password!@#
```

#### Step 4 > CD 서버에 License 임포트

- Administration > License 로 이동하여 설정


#### Step 5 > 서비스 메모리 사용 설정

```console
   $  cd /opt/cloudbees/sda/bin
   $ ./ecconfigure --serverInitMemory 20 --serverMaxMemory 60
   $ ./ecconfigure --agentInitMemory 10 --agentInitMemory 10
   $ ./ecconfigure --repositoryInitMemory 10 --repositoryInitMemory 20
```
