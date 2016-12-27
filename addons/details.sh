# Details
clear
MYIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
if [[ "$MYIP" = "" ]]; then
		MYIP=$(wget -qO- autoscript.kepalatupai.com/addons/ip.php)
fi
echo ""  | tee -a log-install.txt
echo "==============================================================" | tee -a log-install.txt
echo "           Go-VPS.Net | cs@go-vps.net | 085645739470          " | tee log-install.txt
echo "==============================================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ">> Service"  | tee -a log-install.txt
echo "-----------------------------------"  | tee -a log-install.txt
echo "OpenVPN  : 465 1194 (Config: http://$MYIP:81/VPN-Client.zip)"  | tee -a log-install.txt
echo "OpenSSH  : 22 143"  | tee -a log-install.txt
echo "Dropbear : 109 110 443 999"  | tee -a log-install.txt
echo "Badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "Squid    : 80 8080 3128 (Limited IP)"  | tee -a log-install.txt
echo "-----------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ">> Fitur lain"  | tee -a log-install.txt
echo "-----------------------------------"  | tee -a log-install.txt
echo "Webmin           : http://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat           : http://$MYIP:81/vnstat/"  | tee -a log-install.txt
echo "Timezone         : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban         : [on]"  | tee -a log-install.txt
echo "IPv6             : [off]"  | tee -a log-install.txt
echo "-----------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ">> Script"  | tee -a log-install.txt
echo "-----------------------------------"  | tee -a log-install.txt
echo "Tambah User        : tambah namauser passuser"  | tee -a log-install.txt
echo "Cek User Login     : login atau ./login.sh"  | tee -a log-install.txt
echo "List User          : akun"  | tee -a log-install.txt
echo "Kill User 2login+  : ./lmt.sh"  | tee -a log-install.txt
echo "-----------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "=============================================================="  | tee -a log-install.txt
echo ""
echo "REBOOT VPS ANDA!!!!"