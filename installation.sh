
# Eliminamos la interactividad de post-instalación de apt.
export DEBIAN_FRONTEND=noninteractive

# Eliminamos el entorno gráfico y dejamos el run-level de multiusuario con red.
systemctl set-default multi-user.target
systemctl stop NetworkManager
systemctl disable NetworkManager

apt-get remove -yq cupsd
apt-get -yq install 
\ dhcpcd
\ netfilter-persistent
\ iptables-persistent
\ aircrack-ng 
\ dnsmasq
\ hostapd
\ libusb-dev
\ uhubctl
\ net-tools
\ iptables
\ python3
\ python3-pip 
\ python3-rpi.gpio
\ libapache2-mod-php
\ apache2

mkdir -p /opt/AP-soft/

cp -r ./configs /opt/AP-soft/
cp -r ./templates /opt/AP-soft/
chmod +x /opt/AP-soft/configs/vpn/watchdog_vpn.sh
ln -s /opt/AP-soft/configs/vpn/watchdog_vpn.sh /sbin/watchdog_vpn.sh

mv /etc/dnsmasq.conf /etc/dnsmasq.conf_old 
mv /etc/dhcpcd.conf /etc/dhcpcd.conf_old
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf_old

ln -s /opt/AP-soft/configs/access_point/dnsmasq.conf /etc/dnsmasq.conf
ln -s /opt/AP-soft/configs/access_point/dhcpcd.conf /etc/dhcpcd.conf
ln -s /opt/AP-soft/configs/access_point/hostapd.conf /etc/hostapd/hostapd.conf

systemctl enable crond.service
systemctl start crond.service
systemctl disable apache2
systemctl stop apache2

cd /etc/apache2/sites-enabled && rm -rf ./*
cd /etc/apache2/sites-available/ && rm -rf ./*

cp /opt/AP-soft/templates/000-vhost.conf /etc/apache2/sites-available/000-vhost.conf
/usr/sbin/a2ensite 000-vhost

cd /var/www/html/ && rm -rf ./*
cp /opt/AP-soft/templates/web_code/index.php /var/www/html/

cp /opt/AP-soft/templates/udev_rules/40-huawei.rules /etc/udev/rules.d/
