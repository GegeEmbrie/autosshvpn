#!/bin/bash
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
	iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
	iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o eth0 -j MASQUERADE
elif [ $cekvirt = 'OpenVZ' ]; then            
	iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o venet0 -j MASQUERADE
	iptables -t nat -I POSTROUTING -s 10.9.0.0/24 -o venet0 -j MASQUERADE
fi
if [[ -e /etc/pptpd.conf ]]; then
	if [ $cekvirt = 'KVM' ]; then
		iptables -I INPUT -s 10.1.0.1/8 -i ppp0 -j ACCEPT  
		iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
		iptables -t nat -A POSTROUTING -s 10.1.0.1/24 -o eth0 -j MASQUERADE
	elif [ $cekvirt = 'OpenVZ' ]; then
		iptables -I INPUT -s 10.1.0.1/8 -i ppp0 -j ACCEPT  
		iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE  
		iptables -t nat -A POSTROUTING -s 10.1.0.1/24 -o venet0 -j MASQUERADE
	fi
else
	echo "PPTP not installed"
fi

echo "DONE!!"