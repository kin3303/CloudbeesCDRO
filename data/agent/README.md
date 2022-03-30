 
### Cloudbees CD Agent 설치 및 설정

- Cloudbees CD 서버 설치 및 설정을 아래와 같이 진행한다.

#### Step 1 > 소스 다운로드

```console

   $ git clone https://github.com/kin3303/CloudbeesCDRO
   $ cd CloudbeesCDRO
   $ git checkout master
```

#### Step 2 > Agent 설치

```console
   $ sudo su
   $ cd data/agent
   $ chmod 777 install_agent.sh
   $ ./install_agent.sh
``` 

#### Step 3 > 서비스 메모리 사용 설정

```console
   $  cd /opt/cloudbees/sda/bin 
   $ ./ecconfigure --agentInitMemory 10 --agentInitMemory 20
```
