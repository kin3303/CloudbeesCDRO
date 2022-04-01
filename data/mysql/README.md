
### DB 서버 설정

- DB 서버 설치 및 설정을 아래와 같이 진행한다.

#### Step 1 > 소스 다운로드

```console

   $ git clone https://github.com/kin3303/CloudbeesCDRO
   $ cd CloudbeesCDRO
   $ git checkout master
```


#### Step 2 > DB 설치

```console
   $ sudo su
   $ cd data/mysql
   $ chmod 777 install_mysql.sh
   $ ./install_mysql.sh  
   $ password: [임시패스워드로 로그인]
```

#### Step 3 > DB 설정

```console
   $ /usr/local/mysql/bin/mysql -uroot -p 
   > ALTER USER 'root'@'localhost' IDENTIFIED BY 'password!@#';
   > CREATE DATABASE IF NOT EXISTS ecdb;
   > CREATE DATABASE IF NOT EXISTS ecdb_upgrade;
   > CREATE USER 'ecuser'@'%' IDENTIFIED BY 'password!@#';
   > GRANT ALL PRIVILEGES ON ecdb.* TO 'ecuser'@'%';
   > GRANT ALL PRIVILEGES ON ecdb_upgrade.* TO 'ecuser'@'%';
   > FLUSH PRIVILEGES;
   > exit;
```

#### Step 4 > DB 데일리 백업

```console
   $ sudo su
   $ cd data/mysql
   $ chmod 777 bkup_mysql.sh
   $ ./bkup_mysql.sh
```
