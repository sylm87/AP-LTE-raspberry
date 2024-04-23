#apache2
#libapache2-mod-php

export DEBIAN_FRONTEND=noninteractive



mkdir -p /opt/AP-soft/

ln -s /opt/AP-soft/configs/vpn/watchdog_vpn.sh /sbin/watchdog_vpn.sh


systemctl enable crond.service

apt-get -y install libapache2-mod-php apache2
systemctl disable apache2
#systemctl start apache2
systemctl stop apache2

cd /etc/apache2/sites-enabled && rm -rf ./*
cd /etc/apache2/sites-available/ && sudo rm -rf ./*

cp /opt/AP-soft/000-vhost.conf /etc/apache2/sites-available/000-default.conf
cd /var/www/html/ && rm -rf ./*

sudo systemctl stop NetworkManager
sudo systemctl disable  NetworkManager