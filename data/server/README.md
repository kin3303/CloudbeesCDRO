 
### Cloudbees CD 서버 설치 및 설정

- Cloudbees CD 서버 설치 및 설정을 아래와 같이 진행한다.

#### Step 1 > 소스 다운로드

```console

   $ git clone https://github.com/kin3303/DENSO
   $ cd DENSO
   $ git checkout master
```


#### Step 2 > CD, Web, Repo 서버 설치

```console
   $ sudo su
   $ cd data/server
   $ chmod 777 install_cd_server.sh
   $ ./install_cd_server.sh
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


#### Step 5 > CD 서버 메모리 사용 설정

```console
   $ cd /opt/cloudbees/sda/bin
   $ ./ecconfigure --serverInitMemory 30 --serverMaxMemory 70
```
