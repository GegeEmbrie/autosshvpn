#!/bin/bash
clear
echo "=============================="
echo "        Selamat Datang        "
echo "=============================="
echo "Ketik 'I' Untuk VPS Non-Lokal"
echo "Ketik 'L' Untuk VPS Lokal" 
echo "=============================="
read -p "Location : " -e loc
yum update -y

# go to root
cd

# remove unused
yum -y remove sendmail;
yum -y remove httpd;
yum -y remove cyrus-sasl

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

# install wget and curl
yum -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# set repo
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm

OS=`uname -m`;
if [ "$OS" == "x86_64" ]; then
  wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
  rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
else
  wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
  rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.i686.rpm
fi

sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/rpmforge.repo
sed -i -e "/^\[remi\]/,/^\[.*\]/ s|^\(enabled[ \t]*=[ \t]*0\\)|enabled=1|" /etc/yum.repos.d/remi.repo
rm -f *.rpm

# update
yum update -y

# Install Essential Package
yum -y install wondershaper rrdtool screen iftop htop nmap bc nethogs openvpn vnstat ngrep mtr git zsh mrtg unrar rsyslog rkhunter mrtg net-snmp net-snmp-utils expect nano bind-utils
yum -y groupinstall 'Development Tools'
yum -y install cmake
yum -y --enablerepo=rpmforge install axel sslh ptunnel unrar

# Install Webmin
yum update && yum groupinstall "Development Tools"
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.770-1.noarch.rpm
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty
rpm -U webmin-1.770-1.noarch.rpm && chkconfig webmin on
chkconfig webmin on
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

# OpenSSH Setting
sed -i '/#Port 22/a Port 22' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
service sshd restart

# Install Dropbear
yum -y install dropbear
echo "OPTIONS=\"-p 109 -p 110 -p 443 -p 999\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart
cd

chkconfig dropbear on

# Install Webserver Port 81
yum install nginx php libapache2-mod-php php-fpm php-cli php-mysql php-mcrypt libxml-parser-perl -y
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/nginx.conf"
sed -i 's/www-data/nginx/g' /etc/nginx/nginx.conf
mkdir -p /home/vps/public_html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
rm /etc/nginx/conf.d/*
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/vps.conf"
sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf
chmod -R +rx /home/vps
wget -O /home/vps/public_html/uptime.php "http://autoscript.kepalatupai.com/uptime.php1"
wget -O /home/vps/public_html/index.html "https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/index.html1"
service php-fpm restart
service nginx restart
chkconfig php-fpm on
chkconfig nginx on
cd

# Install VNSTAT
yum install vnstat -y
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
if [[ `ifconfig -a | grep "venet0"` ]]
then
cekvirt='OpenVZ'
elif [[ `ifconfig -a | grep "venet0:0"` ]]
then
cekvirt='OpenVZ'
elif [[ `ifconfig -a | grep "venet0:0-00"` ]]
then
cekvirt='OpenVZ'
elif [[ `ifconfig -a | grep "venet0-00"` ]]
then
cekvirt='OpenVZ'
elif [[ `ifconfig -a | grep "eth0"` ]]
then
cekvirt='KVM'
elif [[ `ifconfig -a | grep "eth0:0"` ]]
then
cekvirt='KVM'
elif [[ `ifconfig -a | grep "eth0:0-00"` ]]
then
cekvirt='KVM'
elif [[ `ifconfig -a | grep "eth0-00"` ]]
then
cekvirt='KVM'
fi
if [ $cekvirt = 'KVM' ]; then
	sed -i 's/eth0/eth0/g' config.php
	sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
	sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
	sed -i 's/Internal/Internet/g' config.php
	sed -i '/SixXS IPv6/d' config.php
	cd
elif [ $cekvirt = 'OpenVZ' ]; then
	sed -i 's/eth0/venet0/g' config.php
	sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
	sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
	sed -i 's/Internal/Internet/g' config.php
	sed -i '/SixXS IPv6/d' config.php
	cd
else
	cd
fi

# Install Fail2Ban
yum -y install fail2ban;service fail2ban restart

# Install BadVPN
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# Install Squid
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/squid.sh && bash squid.sh

# Addons
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/addons.sh && sh addons.sh
sed -i 's/1000/500/g' /usr/bin/akun

# OpenVPN
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/cenovpn.sh && bash cenovpn.sh

# Finishing
wget -O /etc/vpnfix.sh "https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/vpnfix.sh"
chmod 777 /etc/vpnfix.sh
sed -i 's/exit 0//g' /etc/rc.d/rc.local
echo "" >> /etc/rc.d/rc.local
echo "bash /etc/vpnfix.sh" >> /etc/rc.d/rc.local
echo "$ screen badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &" >> /etc/rc.d/rc.local
echo "nohup ./cron.sh &" >> /etc/rc.d/rc.local
echo "exit 0" >> /etc/rc.d/rc.local
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/remove.sh && sh remove.sh
rm /root/debian.sh

# Log
clear
wget https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/addons/details.sh && bash details.sh
rm details.sh
history -c