

 
### Cloudbees CD 서버 설치 및 설정

- Cloudbees CD Insight 서버 설치 및 설정을 아래와 같이 진행한다.

#### Step 1 > 소스 다운로드

```console

   $ git clone https://github.com/kin3303/CloudbeesCDRO
   $ cd CloudbeesCDRO
   $ git checkout master
```

#### Step 2 > Ingisht 서버 설치

```console
   $ sudo su
   $ cd data/insight
   $ chmod 777 install_insight.sh
   $ ./install_insight.sh
```
