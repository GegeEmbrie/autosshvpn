AutoScript
=========
AutoScript Setup VPS for seller SSH/VPN

Service
-------
OpenVPN  : 465 1194 (Config: 'http://IP_VPS:81/VPN-Client.zip')
OpenSSH  : 22 143
Dropbear : 109 110 443 999
Badvpn   : badvpn-udpgw port 7300
Squid    : 80 8080 3128 (Limited IP)

Fitur lain
-------
Webmin   	: 'http://IP_VPS:10000/'
vnstat   	: 'http://IP_VPS:81/vnstat/'
Timezone 	: Asia/Jakarta
Fail2Ban 	: [on]
IPv6     	: [off]

Script
-------
Tambah User        : tambah namauser passuser
Cek User Login     : login atau './login.sh'
List User          : akun
Kill User 2login+  : './lmt.sh'
