#!/bin/bash
clear
MYIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$MYIP" = "" ]]; then
		MYIP=$(wget -qO- nyobascript.esy.es/ip.php)
fi
apt-get install dnsmasq -y
echo "interface=tap_soft" >> /etc/dnsmasq.conf
echo "dhcp-range=tap_soft,192.168.7.50,192.168.7.60,12h" >> /etc/dnsmasq.conf
echo "dhcp-option=tap_soft,3,192.168.7.1" >> /etc/dnsmasq.conf
rm -f /etc/init.d/vpnserver
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/vpnserver2 > /etc/init.d/vpnserver
chmod 755 /etc/init.d/vpnserver
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/ipv4_forwarding.conf  > /etc/sysctl.d/ipv4_forwarding.conf
sysctl --system
iptables -t nat -A POSTROUTING -s 192.168.7.0/24 -j SNAT --to-source $MYIP
apt-get install iptables-persistent -y
/etc/init.d/vpnserver restart
/etc/init.d/dnsmasq restart
rm lb-softether.sh