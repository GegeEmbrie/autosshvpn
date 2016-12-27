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
	rm /root/.bash_history
	rm -rf /root/dropbear-2014.63
	rm -rf /root/badvpn-1.999.127
	rm /root/dropbear-2014.63.tar.bz2
	rm /root/dropbear_2014.63-0.1.dsc
	rm /root/dropbear_2014.63-0.1.tar.gz
	rm /root/dropbear_2014.63-0.1_*.changes
	rm /root/dropbear_2014.63-0.1_*.deb
	rm /root/badvpn-1.999.127.tar.bz2
	rm /root/jcameron-key.asc
	rm /root/squid.sh
	rm /root/addons.sh
	rm /root/remove.sh
	echo "Removed"
elif [ $OSystem = 'centos' ]; then
	rm -f /root/easy-rsa-2.2.0_master.tar.gz
	rm -f /root/centos.sh
	rm -f /root/lzo-1.08-4.rf.src.rpm
	rm -f /root/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
	rm -f /root/webmin-1.770-1.noarch.rpm
	rm -f /root/cenovpn.sh
fi