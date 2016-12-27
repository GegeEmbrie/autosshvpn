#!/bin/bash
yum -y update
yum -y install sslh

sed -i 's/ -p 443//g' /etc/sysconfig/dropbear
service dropbear restart

rm -f /etc/rc.d/init.d/sslh
curl https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/censslh > /etc/rc.d/init.d/sslh
chmod 777 /etc/rc.d/init.d/sslh

service sslh restart