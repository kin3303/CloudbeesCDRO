#!/bin/bash

#cleaning
sudo apt update
sudo service mysql stop
sudo killall mysqld
sudo apt-get remove --purge mysql* 
sudo rm -rf /usr/local/mysql/data
sudo rm -rf /etc/my.cnf

# copy configuration file
sudo cp ./mysql.cnf /etc/my.cnf

#port allow
sudo apt install ufw
sudo ufw allow mysql

# library install
sudo apt install libncurses5 -y 

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

# register service
sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
RUN  sed -i -e "s\basedir=\basedir=/usr/local/mysql\g" /etc/init.d/mysqld
RUN  sed -i -e "s\datadir=\datadir=/usr/local/mysql/data\g" /etc/init.d/mysqld

# mysql --initialize : installing
sudo bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

# create RSA files
sudo bin/mysql_ssl_rsa_setup

# mysql start & access
sudo /usr/local/mysql/bin/mysqld_safe --user=mysql &
sudo /usr/local/mysql/bin/mysql -uroot -p
