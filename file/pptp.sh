#!/bin/bash
clear
apt-get install pptpd -y

MYIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$MYIP" = "" ]]; then
		MYIP=$(wget -qO- nyobascript.esy.es/ip.php)
fi

echo "localip $MYIP" >> /etc/pptpd.conf
echo "remoteip 10.1.0.1-100" >> /etc/pptpd.conf

echo "ms-dns 8.8.8.8" >> /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >> /etc/ppp/pptpd-options

echo "ifconfig ppp0 mtu 1400" >> /etc/ppp/ip-up

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/ipv4_forwarding.conf
sysctl --system

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
	iptables -I INPUT -s 10.1.0.1/8 -i ppp0 -j ACCEPT  
	iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
	iptables -t nat -A POSTROUTING -s 10.1.0.1/24 -o eth0 -j MASQUERADE
elif [ $cekvirt = 'OpenVZ' ]; then
	iptables -I INPUT -s 10.1.0.1/8 -i ppp0 -j ACCEPT  
	iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE  
	iptables -t nat -A POSTROUTING -s 10.1.0.1/24 -o venet0 -j MASQUERADE
fi

service pptpd restart