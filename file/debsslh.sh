#!/bin/bash
aptitude update
aptitude install sslh -y

sed -i 's/DROPBEAR_PORT=443/DROPBEAR_PORT=441/g' /etc/default/dropbear
service dropbear restart

aptitude install build-essential
cd /tmp
wget http://www.rutschle.net/tech/sslh-1.10.tar.gz
tar xvzf sslh-1.10.tar.gz
cd sslh-1.10
make install

cd /etc/default
rm -rf /etc/default/sslh
curl http://autoscript.kepalatupai.com/file/debsslh > /etc/default/sslh
chmod 644 /etc/default/sslh

service sslh restart


