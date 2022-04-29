#!/bin/bash

#configuration
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

RUN_USER=cbcd 
RUN_GROUP=cbcd
RUN_UID=2003
RUN_GID=2003
HOME_DIR=/home/${RUN_USER}
INSTALL_DIR=/opt/cloudbees/sda
  
sudo rm -rf ${HOME_DIR} && \ 
sudo rm -rf ${INSTALL_DIR} && \
sudo mkdir -p ${HOME_DIR}

sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# user & group
sudo groupadd --gid ${RUN_GID} ${RUN_GROUP} && \
sudo useradd --uid ${RUN_UID} --gid ${RUN_GID} --home-dir ${HOME_DIR} --shell /bin/bash ${RUN_USER}
serverUser="${RUN_USER}"
serverGroup="${RUN_GROUP}"


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

sudo chmod -R "u=rwX,g=rX,o=rX" ${INSTALL_DIR}/ && \ 
sudo chown -R ${RUN_USER}:${RUN_GROUP} ${INSTALL_DIR}/ && \
sudo chown -R ${RUN_USER}:${RUN_GROUP} ${HOME_DIR} 

sudo /etc/init.d/commanderServer restart
