
## Let's Encrypt(Certbot) 인증서 설치

아래와 같이 인증서를 설치할 수 있다.

```console
  $ /etc/init.d/commanderApache stop
  $ apt install software-properties-common
  $ add-apt-repository universe
  $ add-apt-repository ppa:certbot/certbot
  $ apt update
  $ apt upgrade
  $ apt install certbot python3-certbot-apache
  $ certbot certonly --apache -d [도메인명 ex> cbcd.idtplateer.com]
  $ systemctl stop apache2
  $  vi /opt/cloudbees/sda/apache/conf/ssl.conf
       SSLCertificateFile "/etc/letsencrypt/live/cbcd.idtplateer.com/cert.pem"
       SSLCertificateKeyFile  "/etc/letsencrypt/live/cbcd.idtplateer.com/privkey.pem"
       SSLCertificateChainFile "/etc/letsencrypt/live/cbcd.idtplateer.com/chain.pem"
  $ /etc/init.d/commanderApache start
```
