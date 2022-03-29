#!/bin/bash


#cleaning
sudo apt update
sudo service mysql stop
sudo killall mysqld
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get remove --purge mysql* 
sudo rm -rf /usr/local/mysql/data
sudo rm -rf /lib/systemd/system/mysql.service

# create mysql.service
sudo cp ./mysql.service /usr/lib/systemd/system/mysql.service

#port
sudo apt install ufw
sudo ufw allow mysql

# library install
sudo apt install libncurses5 -y

sudo rm -rf /etc/my.cnf
sudo cp ./mysql.cnf /etc/my.cnf

# group & user add
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql

# mysql install file download & decompress
cd /usr/local
sudo wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz
sudo tar xvf mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz

# symbolic link : mysql-version-os -> mysql
sudo ln -s /usr/local/mysql-8.0.28-linux-glibc2.12-x86_64 mysql

cd /var/run
sudo mkdir mysqld
sudo chown mysql mysqld
sudo chgrp mysql mysqld

# directory setting
cd /usr/local/mysql
sudo mkdir mysql-files sudo 
sudo chown mysql:mysql mysql-files
sudo chmod 750 mysql-files


# mysql --initialize : installing
sudo bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
#ls >> /res2.txt

# create RSA files
sudo bin/mysql_ssl_rsa_setup

sudo systemctl daemon-reload


sudo service mysql start
sudo systemctl enable mysql

# mysql start & access
#sudo bin/mysqld_safe --user=mysql & sudo bin/mysql -uroot -p
