#!/bin/bash
service dropbear stop
apt-get update
apt-get install build-essential -y
OS=`uname -m`;
if [ $OS = 'i686' ]; then
	wget http://www.softether-download.com/files/softether/v4.14-9529-beta-2015.02.02-tree/Linux/SoftEther_VPN_Server/32bit_-_Intel_x86/softether-vpnserver-v4.14-9529-beta-2015.02.02-linux-x86-32bit.tar.gz
	tar zxf softether-vpnserver-v4.14-9529-beta-2015.02.02-linux-x86-32bit.tar.gz
elif [ $OS = 'x86_64' ]; then
	wget http://www.softether-download.com/files/softether/v4.14-9529-beta-2015.02.02-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.14-9529-beta-2015.02.02-linux-x64-64bit.tar.gz
	tar zxf softether-vpnserver-v4.14-9529-beta-2015.02.02-linux-x64-64bit.tar.gz
fi
cd vpnserver
make
# enter 3 kali
cd ..
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpncmd
chmod 700 vpnserver
curl -s http://autoscript.kepalatupai.com/file/vpnserver1 > /etc/init.d/vpnserver
chmod 755 /etc/init.d/vpnserver
mkdir /var/lock/subsys
update-rc.d vpnserver defaults
/etc/init.d/vpnserver start
cd /usr/local/vpnserver/
./vpncmd
# pilih 1 > enter > enter > ServerPasswordSet
rm /root/debsevpn.sh