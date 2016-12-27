#!/bin/sh

#update
apt-get update
apt-get upgrade -y

#install vnc
apt-get install gnome-desktop-environment -y
apt-get install xfonts-100dpi -y
apt-get install xfonts-100dpi-transcoded -y
apt-get install xfonts-75dpi -y
apt-get install xfonts-75dpi-transcoded -y
apt-get install xfonts-base -y
apt-get install tightvncserver -y
tightvncserver :1
tightvncserver -kill :1
wget -O ~/.vnc/xstartup "http://autoscript.kepalatupai.com/file/xstartup"
tightvncserver -geometry 1024x768 :1

# info
clear
echo "==============================================="  | tee -a log-install.txt
echo "Don't Change This" | tee log-install.txt
echo "Hargai Saya Sebagai Pembuat Auto Script ini" | tee log-install.txt
echo "Xpid Conex | Gegefcp@gmail.com | VPS/SSH Mall F2C "| tee log-install.txt
echo "==============================================="  | tee -a log-install.txt