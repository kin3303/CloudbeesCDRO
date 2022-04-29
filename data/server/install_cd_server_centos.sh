#!/bin/bash

#configuration
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

#install packages
sudo yum update -y
sudo yum -y install  firewalld 
sudo systemctl start firewalld 

#port allow
sudo firewall-cmd --zone=public --permanent --add-port=8000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8443/tcp
sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
sudo firewall-cmd --zone=public --permanent --add-port=443/tcp
sudo firewall-cmd --zone=public --permanent --add-port=7080/tcp
sudo firewall-cmd --zone=public --permanent --add-port=7443/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8200/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8900/tcp

# user & group 
serverUser="ubuntu"
serverGroup="ubuntu" 

EXIST_USER=0
UIDS=$(getent passwd | cut -d: -f1)
for user in ${UIDS}
do
   group=$(getent group ${user} | cut -d: -f1)
   if [[ "${user}" = "${serverUser}" && "${group}" = "${serverGroup}" ]]
   then
      EXIST_USER=1
   fi
done

if [[ ${EXIST_USER} -eq 0 ]]
then
   echo "Please check if the user you entered is a valid user."
   exit 1;
fi

#download installer
sudo yum update -y
sudo yum -y install wget  
sudo wget https://downloads.cloudbees.com/cloudbees-cd/Release_10.4/10.4.2.153852/linux/CloudBeesFlow-x64-10.4.2.153852
flowInstaller="CloudBeesFlow-x64-10.4.2.153852"

#install cd server & web server
sudo chmod +x ./${flowInstaller}

sudo ./${flowInstaller} \
    --mode silent \
    --installServer \
    --installAgent \
    --installDatabase \
    --installWeb \
    --installRepository \
    --unixServerUser "${serverUser}" \
    --unixServerGroup  "${serverGroup}"  \
    --unixAgentGroup  "${serverUser}" \
    --unixAgentUser  "${serverGroup}"

rm -rf ${flowInstaller}

if [[ "${?}" -ne 0 ]]
then
   echo "Installation failed.."
   exit 1;
fi

sudo chmod +x mysql-connector-java-8.0.27_ubuntu_20.04.jar
sudo cp ./mysql-connector-java-8.0.27_ubuntu_20.04.jar /opt/cloudbees/sda/server/lib/mysql-connector-java.jar

sudo /etc/init.d/commanderServer restart
