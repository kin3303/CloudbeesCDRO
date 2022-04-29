#!/bin/bash

# Remote Server
read -p 'Enter the cloudbees cd server ip: ' REMOTE_SERVER  
if [ ! -z "$REMOTE_SERVER" ]
then
  remoteServer=$REMOTE_SERVER 
else
  echo "Please make sure you put the ip address of the cloudbees cd server."
  exit 1
fi

# User & Group
agentUser="ubuntu" 
agentGroup="ubuntu" 
EXIST_USER=0
UIDS=$(getent passwd | cut -d: -f1)
for user in ${UIDS}
do
  group=$(getent group ${user} | cut -d: -f1)
  if [[ "${user}" = "${agentUser}" && "${group}" = "${agentGroup}" ]]
  then
    EXIST_USER=1
  fi
done

if [[ ${EXIST_USER} -eq 0 ]]
then
	echo "Please check if the user you entered is a valid user."
	exit 1;
fi

# CloudbeesCDRO Account
userAccount="admin" 
userPass="changeme"

# Resource Name
agentIP="$( hostname -I | awk '{print $1}')"
resourceName=$agentIP

# Firewall
sudo apt install -y ufw
sudo ufw allow 6800/tcp
sudo ufw allow 7800/tcp
sudo ufw allow 61613/tcp

# Download Installer
sudo wget https://downloads.cloudbees.com/cloudbees-cd/Release_10.4/10.4.2.153852/linux/CloudBeesFlow-x64-10.4.2.153852
flowInstaller="CloudBeesFlow-x64-10.4.2.153852"

# Silent install
chmod +x ./${flowInstaller}

./${flowInstaller} \
  --mode silent \
  --installAgent \
  --remoteServer "${remoteServer}" \
  --remoteServerUser "${userAccount}" \
  --remoteServerPassword "${userPass}" \
  --unixAgentGroup  "${agentUser}" \
  --unixAgentUser  "${agentGroup}" \
  --agentLocalPort "6800" \
  --agentPort "7800"

rm -rf ${flowInstaller}

if [[ "${?}" -ne 0 ]]
then
   echo "Agent installation failed.."
   exit 1
fi

# Register agent to server 
/opt/cloudbees/sda/bin/ectool --server "${remoteServer}" login "${userAccount}" "${userPass}" 
/opt/cloudbees/sda/bin/ectool deleteResource ${resourceName}
/opt/cloudbees/sda/bin/ectool createResource ${resourceName} --hostName  ${agentIP} 
/opt/cloudbees/sda/bin/ectool pingResource ${resourceName}

tail -F /opt/cloudbees/sda/logs/agent/agent.log
