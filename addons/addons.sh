#!/bin/bash
if [[ -e /etc/debian_version ]]; then
	OSystem=debian
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OSystem=centos
	RCLOCAL='/etc/rc.d/rc.local'
	chmod +x /etc/rc.d/rc.local
else
	echo "Looks like you aren't running this installer on a Debian, Ubuntu or CentOS system"
	exit
fi

if [ $OSystem = 'debian' ]; then
	apt-get install python -y
elif [ $OSystem = 'centos' ]; then
	yum install python -y
fi

curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/akun > /usr/bin/akun
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/lmtdb > /usr/bin/lmtdb
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/lmtop > /usr/bin/lmtop
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/login > /usr/bin/login
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/tambah > /usr/bin/tambah
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/addpptp > /usr/bin/addpptp
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/renew > /usr/bin/renew
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/expired.sh > /root/expired.sh
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/lmt.sh > /root/lmt.sh
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/login.sh > /root/login.sh
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/addpptp.sh > /root/addpptp.sh
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/cron.sh > /usr/bin/cron.sh
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/speedtest_cli.py
chmod +x /root/expired.sh
chmod +x /root/lmt.sh
chmod +x /root/login.sh
chmod +x /usr/bin/login
chmod +x /usr/bin/tambah
chmod +x /usr/bin/akun
chmod +x /usr/bin/lmtdb
chmod +x /usr/bin/lmtop
chmod +x /usr/bin/addpptp
chmod +x /usr/bin/renew
chmod +x /root/addpptp.sh
chmod +x /usr/bin/cron.sh