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
read -p "Post TCP1 : " -e -i 465 TCP1
read -p "Post TCP2 : " -e -i 1194 TCP2

MYIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$MYIP" = "" ]]; then
		MYIP=$(wget -qO- nyobascript.esy.es/ip.php)
fi

PORT1="s/xxx/$TCP1/g";
PORT2="s/xxx/$TCP2/g";

if [[ "$TCP1" = "443" ]]; then
		service dropbear stop
		apt-get purge dropbear -y
fi

if [[ "$TCP2" = "443" ]]; then
		service dropbear stop
		apt-get purge dropbear -y
fi


service vpnserver stop
rm -rf /etc/init.d/vpnserver
rm -rf /usr/local/vpnserver
apt-get purge openvpn -y
rm -rf /etc/openvpn
rm -rf /usr/share/doc/openvpn
rm -rf /home/vps/public_html/VPN-client.zip
rm -rf /etc/iptables.conf
rm -rf /etc/network/if-up.d/iptables
sed -i 's/iptables-restore//g' /etc/rc.local

apt-get update -y
apt-get install openvpn unzip zip -y
cd /usr/share/doc/openvpn/examples/
cp -a /usr/share/doc/openvpn/examples/easy-rsa /etc/openvpn/
cd /etc/openvpn/easy-rsa/2.0
chmod 777 /etc/openvpn/easy-rsa/2.0
chmod 777 /etc/openvpn/easy-rsa/2.0/*
source ./vars
./clean-all
echo -e "\n\n\n\n\n\n\n" | ./build-ca
./build-key-server server01
./build-dh
openvpn --genkey --secret keys/ta.key

cd /etc/openvpn
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/server-tcp1.conf >> /etc/openvpn/server-tcp1.conf
sed -i $PORT1 /etc/openvpn/server-tcp1.conf;
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/server-tcp2.conf >> /etc/openvpn/server-tcp2.conf
sed -i $PORT2 /etc/openvpn/server-tcp2.conf;
mkdir /etc/openvpn/keys
cp /etc/openvpn/easy-rsa/2.0/keys/{ca.crt,server01.crt,server01.key,dh1024.pem,ta.key} /etc/openvpn/keys/
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn
/etc/init.d/openvpn restart
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/forwarding.conf >> /etc/sysctl.d/forwarding.conf
sysctl -p /etc/sysctl.d/forwarding.conf

if [ $cekvirt = 'KVM' ]; then
	iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
	iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o eth0 -j MASQUERADE
elif [ $cekvirt = 'OpenVZ' ]; then
	iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o venet0 -j MASQUERADE
	iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o venet0 -j MASQUERADE
fi

mkdir clientconfig
cp /etc/openvpn/easy-rsa/2.0/keys/{ca.crt,ta.key} clientconfig/
cd clientconfig

cd /etc/openvpn/clientconfig/
mv /etc/openvpn/clientconfig/ca.crt /etc/openvpn/clientconfig/ca.conf
CA=`cat /etc/openvpn/clientconfig/ca.conf`;
apt-get install zip -y

client1="client
dev tun
proto tcp

remote $MYIP $TCP1
http-proxy-retry
http-proxy $MYIP 80

resolv-retry infinite
route-method exe

nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

<ca>
$CA

</ca>
"

echo "$client1" > $HOSTNAME-$TCP1.ovpn

client2="client
dev tun
proto tcp

remote $MYIP $TCP2
http-proxy-retry
http-proxy $MYIP 80

resolv-retry infinite
route-method exe

nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

<ca>
$CA

</ca>
"

echo "$client2" > $HOSTNAME-$TCP2.ovpn

rm /etc/openvpn/clientconfig/ca.conf
rm /etc/openvpn/clientconfig/ta.key
zip VPN-Client.zip *
mv /etc/openvpn/clientconfig/VPN-Client.zip /home/vps/public_html
echo "Download Config"
echo "http://$MYIP:81/VPN-Client.zip"
rm /root/debovpn.sh
