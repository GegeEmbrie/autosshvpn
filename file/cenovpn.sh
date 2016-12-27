#!/bin/bash
clear
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
echo "======================"
echo "Tentunkan port OpenVPN"
echo "======================"
read -p "Post TCP : " -e -i 465 TCP
read -p "Post UDP : " -e -i 1194 UDP

MYIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$MYIP" = "" ]]; then
		MYIP=$(wget -qO- autoscript.kepalatupai.com/addons/ip.php)
fi

ip="s/ip/$MYIP/g";

PORT1="s/xxx/$TCP/g";
PORT2="s/xxx/$UDP/g";

if [[ "$TCP" = "443" ]]; then
		service dropbear stop
		yum remove -y dropbear
fi

if [[ "$UDP" = "443" ]]; then
		service dropbear stop
		yum remove -y dropbear
fi


service vpnserver stop
rm -rf /etc/init.d/vpnserver
rm -rf /usr/local/vpnserver
yum remove openvpn -y
rm -rf /etc/openvpn
rm -rf /usr/share/doc/openvpn
rm -rf /home/vps/public_html/VPN-client.zip
rm -rf /etc/iptables.conf
rm -rf /etc/network/if-up.d/iptables
sed -i 's/iptables-restore//g' /etc/rc.local

yum -y install wget gcc make rpm-build autoconf.noarch zlib-devel pam-devel openssl-devel
wget http://openvpn.net/release/lzo-1.08-4.rf.src.rpm
OS=`uname -m`;
if [ $OS = 'i686' ]; then
	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
elif [ $OS = 'x86_64' ]; then
	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
fi
rpmbuild --rebuild lzo-1.08-4.rf.src.rpm
rpm -Uvh lzo-*.rpm
rpm -Uvh rpmforge-release*
yum update -y
yum install openvpn -y
wget https://github.com/downloads/OpenVPN/easy-rsa/easy-rsa-2.2.0_master.tar.gz
tar -zxvf easy-rsa-2.2.0_master.tar.gz
cp -R easy-rsa-2.2.0_master/easy-rsa/ /etc/openvpn/
cd /etc/openvpn/easy-rsa/2.0
chmod 755 *
source ./vars
./vars
./clean-all
echo -e "\n\n\n\n\n\n\n" | ./build-ca
./build-key-server server
./build-dh
./build-key kepalatupai

yum install -y zip unzip
wget http://safesrv.net/public/openvpn-auth-pam.zip
unzip openvpn-auth-pam.zip
rm -rf openvpn-auth-pam.zip
mv openvpn-auth-pam.so /etc/openvpn/openvpn-auth-pam.so

cd /etc/openvpn
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/server-tcp.conf >> /etc/openvpn/server-tcp.conf
sed -i $ip /etc/openvpn/server-tcp.conf;
sed -i $PORT1 /etc/openvpn/server-tcp.conf;
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/server-udp.conf >> /etc/openvpn/server-udp.conf
sed -i $ip /etc/openvpn/server-udp.conf;
sed -i $PORT2 /etc/openvpn/server-udp.conf;
service openvpn restart
chkconfig openvpn on

sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/yum.repos.d/rpmforge.repo
sysctl -p

iptables -F
if [ $cekvirt = 'KVM' ]; then
	iptables -t nat -A POSTROUTING -s 10.9.8.0/24 -o eth0 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.9.7.0/24 -o eth0 -j MASQUERADE
elif [ $cekvirt = 'OpenVZ' ]; then
	iptables -t nat -A POSTROUTING -s 10.9.8.0/24 -o venet0 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.9.7.0/24 -o venet0 -j MASQUERADE
fi
service iptables save

mkdir /etc/openvpn/dlconfig
cd /etc/openvpn/dlconfig
cp /etc/openvpn/easy-rsa/2.0/keys/{ca.crt,kepalatupai.key,kepalatupai.crt,kepalatupai.csr} /etc/openvpn/dlconfig

mv /etc/openvpn/dlconfig/ca.crt /etc/openvpn/dlconfig/ca.conf
mv /etc/openvpn/dlconfig/kepalatupai.key /etc/openvpn/dlconfig/kepalatupaikey.conf

CA=`cat /etc/openvpn/dlconfig/ca.conf`;
KEY=`cat /etc/openvpn/dlconfig/kepalatupaikey.conf`;


client1="client
dev tun
proto tcp
remote $MYIP $TCP
route-method exe
resolv-retry infinite
nobind
tun-mtu 1500
tun-mtu-extra 32
mssfix 1450
persist-key
persist-tun
cert kepalatupai.crt
auth-user-pass
comp-lzo
verb 3

<ca>
$CA

</ca>

<key>
$KEY

</key>

"

echo "$client1" > $HOSTNAME-$TCP.ovpn

client2="client
dev tun
proto udp
remote $MYIP $UDP
route-method exe
resolv-retry infinite
nobind
tun-mtu 1500
tun-mtu-extra 32
mssfix 1450
persist-key
persist-tun
cert kepalatupai.crt
auth-user-pass
comp-lzo
verb 3

<ca>
$CA

</ca>

<key>
$KEY

</key>

"

echo "$client2" > $HOSTNAME-$UDP.ovpn

rm -rf /etc/openvpn/dlconfig/{ca.conf,kepalatupaikey.conf}
zip VPN-Client.zip *
mkdir /home/vps
mkdir /home/vps/public_html
chmod 777 /home/vps/*
mv /etc/openvpn/dlconfig/VPN-Client.zip /home/vps/public_html
echo "Download Config"
echo "http://$MYIP:81/VPN-Client.zip"
