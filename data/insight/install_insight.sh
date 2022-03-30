
#!/bin/bash
  
read -p 'Enter the cloudbees cd server ip: ' REMOTE_SERVER
 
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sysctl -w vm.max_map_count=262144 
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

sudo apt update
sudo apt install net-tools

agentUser="ubuntu"
agentGroup="ubuntu" 
agentIP="$( hostname -I | awk '{print $1}')"

if [ ! -z "$agentIP" ]
then
  echo "Agent ip address: ${agentIP}"
else
  echo "Unable to verify private IP address."
  exit 1
fi  

if [ ! -z "$REMOTE_SERVER" ]
then
  remoteServer=$REMOTE_SERVER 
else
  echo "Please make sure you put the ip address of the cloudbees cd server."
  exit 1
fi
 
sudo wget https://downloads.cloudbees.com/cloudbees-cd/Release_10.4/10.4.2.153852/linux/CloudBeesFlowDevOpsInsightServer-x64-10.4.2.153852
insightInstaller="CloudBeesFlowDevOpsInsightServer-x64-10.4.2.153852"


#Check user and group

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

rm -rf /usr/share/elasticsearch/data 
mkdir -p /usr/share/elasticsearch/data && chmod 777 /usr/share/elasticsearch/data

# Silent Installation

chmod +x ./${insightInstaller}

./${insightInstaller} \
  --mode silent \
  --disableSSL \
  --elasticsearchRegenerateCertificates \
  --hostName ${agentIP} \
  --temp "/tmp" \
  --unixServerUser "${agentUser}" \
  --unixServerGroup  "${agentGroup}" \
  --remoteServer "${remoteServer}" \
  --remoteServerPassword "changeme" \
  --remoteServerUser "admin" \
  --elasticsearchDataDirectory "/usr/share/elasticsearch/data"
	
if [[ "${?}" -ne 0 ]]
then
   echo "Installation failed.."
   exit 1;
fi

tail -F /opt/cloudbees/sda/logs/reporting/elasticsearch.log
