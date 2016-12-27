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

curl -s http://autoscript.kepalatupai.com/addons/akun > /usr/bin/akun
curl -s http://autoscript.kepalatupai.com/addons/lmtdb > /usr/bin/lmtdb
curl -s http://autoscript.kepalatupai.com/addons/lmtop > /usr/bin/lmtop
curl -s http://autoscript.kepalatupai.com/addons/login > /usr/bin/login
curl -s http://autoscript.kepalatupai.com/addons/tambah > /usr/bin/tambah
curl -s http://autoscript.kepalatupai.com/addons/addpptp > /usr/bin/addpptp
curl -s http://autoscript.kepalatupai.com/addons/renew > /usr/bin/renew
curl -s http://autoscript.kepalatupai.com/addons/expired.sh > /root/expired.sh
curl -s http://autoscript.kepalatupai.com/addons/lmt.sh > /root/lmt.sh
curl -s http://autoscript.kepalatupai.com/addons/login.sh > /root/login.sh
curl -s http://autoscript.kepalatupai.com/addons/addpptp.sh > /root/addpptp.sh
curl -s http://autoscript.kepalatupai.com/addons/cron.sh > /usr/bin/cron.sh
wget http://autoscript.kepalatupai.com/addons/speedtest_cli.py
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