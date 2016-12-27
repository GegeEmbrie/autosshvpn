# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$MYIP" = "" ]]; then
		MYIP=$(wget -qO- autoscript.kepalatupai.com/addons/ip.php)
fi
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

MYIP2="s/xxxxxxxxx/$MYIP/g";

if [ $OSystem = 'debian' ]; then
	apt-get -y update
	apt-get -y install squid3
	wget -O /etc/squid3/squid.conf "http://autoscript.kepalatupai.com/file/squid3.conf"
	sed -i $MYIP2 /etc/squid3/squid.conf;
	service squid3 restart
	rm squid.sh
elif [ $OSystem = 'centos' ]; then
	yum -y install squid
	wget -O /etc/squid/squid.conf "http://autoscript.kepalatupai.com/file/squid3.conf"
	sed -i $MYIP2 /etc/squid/squid.conf;
	service squid restart
	chkconfig squid on
fi

