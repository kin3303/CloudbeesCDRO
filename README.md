
DB 설치 후 작업

```
/usr/local/mysql/bin/mysql -uroot -p
 
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password!@#'
CREATE DATABASE IF NOT EXISTS ecdb;
CREATE DATABASE ecdb_upgrade;
GRANT ALL PRIVILEGES ON ecdb.* TO 'root'@'localhost';
GRANT ALL PRIVILEGES ON ecdb_upgrade.* TO 'root'@'localhost';
```
