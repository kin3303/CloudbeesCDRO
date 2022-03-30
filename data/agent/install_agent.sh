#!/bin/bash

read -p 'Enter the cloudbees cd server ip: ' REMOTE_SERVER  

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

agentUser="ubuntu" 
agentGroup="ubuntu" 
userAccount="admin" 
userPass="changeme" 
agentIP="$( hostname -I | awk '{print $1}')"
resourceName=$agentIP

sudo wget https://downloads.cloudbees.com/cloudbees-cd/Release_10.4/10.4.2.153852/linux/CloudBeesFlow-x64-10.4.2.153852
flowInstaller="CloudBeesFlow-x64-10.4.2.153852"

if [ ! -z "$REMOTE_SERVER" ]
then
  remoteServer=$REMOTE_SERVER 
else
  echo "Please make sure you put the ip address of the cloudbees cd server."
  exit 1
fi

# Verify that the user and group exist
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

# Silent install
chmod +x ./${flowInstaller}

./${flowInstaller} \
  --mode silent \
  --installAgent \
  --remoteServer "${remoteServer}" \
  --remoteServerUser "${userAccount}" \
  --remoteServerPassword "${userPass}"
  --unixAgentGroup  "${agentUser}" \
  --unixAgentUser  "${agentGroup}" \
  --agentLocalPort "6800" \
  --agentPort "7800" \

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
