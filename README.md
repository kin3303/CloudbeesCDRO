
## Step 1 > 소스 다운로드

```console

# git clone https://github.com/kin3303/DENSO
# cd DENSO
# git checkout master
```


## Step 2 > DB 설치

```console
# cd data/mysql
# chmod 777 install_mysql.sh
# sudo ./install_mysql.sh 
# systemctl status mysql
```

## Step 3 > DB 설정

```console
# /usr/local/mysql/bin/mysql -uroot -p
> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password!@#'
> CREATE DATABASE IF NOT EXISTS ecdb;
> CREATE DATABASE ecdb_upgrade;
> GRANT ALL PRIVILEGES ON ecdb.* TO 'root'@'localhost';
> GRANT ALL PRIVILEGES ON ecdb_upgrade.* TO 'root'@'localhost';
> exit
```

