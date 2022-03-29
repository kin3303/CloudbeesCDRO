#!/bin/bash

#configuration
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

timedatectl set-timezone Asia/Seoul

serverUser="ubuntu"
serverGroup="ubuntu"


#download installer
sudo wget https://downloads.cloudbees.com/cloudbees-cd/Release_10.4/10.4.0.153077/linux/CloudBeesFlow-x64-10.4.0.153077
flowInstaller="CloudBeesFlow-x64-10.4.0.153077"

#check user & group exist
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

if [[ "${?}" -ne 0 ]]
then
   echo "Installation failed.."
   exit 1;
fi

sudo chmod +x mysql-connector-java-8.0.27_ubuntu_20.04.jar
sudo cp ./mysql-connector-java-8.0.27_ubuntu_20.04.jar /opt/cloudbees/sda/server/lib/mysql-connector-java.jar

/etc/init.d/commanderServer restart
