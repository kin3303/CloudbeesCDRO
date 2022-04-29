#!/bin/bash

sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

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

# port 
sudo apt install -y ufw
sudo ufw allow 8000/tcp
sudo ufw allow 8443/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 7080/tcp
sudo ufw allow 7443/tcp 
sudo ufw allow 8200/tcp
sudo ufw allow 8900/tcp
  
#download installer
sudo apt install -y wget
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

/etc/init.d/commanderServer restart
