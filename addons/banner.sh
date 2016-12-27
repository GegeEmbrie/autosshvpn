issue="==========================================================================
                            Selamat datanng
                           SSH  Kepala Tupai
==========================================================================
      Term of Service             #   Port Info
      - Max login 3               #   - OpenSSH : 22 143
      - No DDoS                   #   - Dropbear : 109 110 443 999
      - No Hacking                #   - Badvpn : badvpn-udpgw port 7300
      - No Torrent                #   - Squid : 80 8080 3128 (Limited IP)
	  - No Ilegal Activities      #   - OpenVPN : 465 1194
==========================================================================
Credit by 
Gege Desembri : https://www.facebook.com/GegeEmbrie
Kepala Tupai : http://kepalatupai.com
SSH Kepala Tupai : http://ssh.kepalatupai.com
Go-RDP.Net : https://www.facebook.com/groups/govps.net
===========================================================================
"

rm -rf /etc/issue.net
echo "$issue" > /etc/issue.net
chmod 777 /etc/issue.net

sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
rm -rf /etc/default/dropbear
curl -s https://raw.githubusercontent.com/GegeEmbrie/autosshvpn/master/file/dropbear >> /etc/default/dropbear
chmod 644 /etc/default/dropbear

service ssh restart
service dropbear restart