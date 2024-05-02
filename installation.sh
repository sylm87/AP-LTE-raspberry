
# Eliminamos la interactividad de post-instalación de apt.
echo "Ignorando interactividad APT"
export DEBIAN_FRONTEND=noninteractive

# Eliminamos el entorno gráfico y dejamos el run-level de multiusuario con red.
echo "Cambiando el modo gráfico a modo consola multiusuario (runlevel 3)" 
systemctl set-default multi-user.target

echo "Deshabilitando NetworkManager"
systemctl stop NetworkManager
systemctl disable NetworkManager

echo "Instalando dependencias APT"

apt-get -yq install \
netfilter-persistent \
iptables-persistent \
aircrack-ng \
dnsmasq \
hostapd \
libusb-dev \
uhubctl \
net-tools \
iptables \
python3 \
python3-pip \
python3-rpi.gpio \
libapache2-mod-php \
apache2 \
git \
ssh

apt-get remove -yq ^cups dhcpcd udhcpc udhcpd 2> /dev/null

echo "Habilitando SSH"
systemctl enable ssh
systemctl start ssh 2> /dev/null

echo "Creando directorio base en /opt y cargando ficheros de configuración"
rm -rf /opt/AP-soft/ 2> /dev/null
mkdir -p /opt/AP-soft/

cp -r ./configs /opt/AP-soft/
cp -r ./templates /opt/AP-soft/
chmod +x /opt/AP-soft/configs/vpn/watchdog_vpn.sh
chmod +x /opt/AP-soft/configs/web-editor/on_off_editor.sh
rm -rf /sbin/watchdog_vpn.sh
ln -s /opt/AP-soft/configs/vpn/watchdog_vpn.sh /sbin/watchdog_vpn.sh 2> /dev/null
rm -rf /sbin/on_off_editor.sh
ln -s /opt/AP-soft/configs/web-editor/on_off_editor.sh /sbin/on_off_editor.sh 2> /dev/null

echo "Sustituyendo ficheros de configuración originales"
mv /etc/dnsmasq.conf /etc/dnsmasq.conf_old 
#mv /etc/dhcpcd.conf /etc/dhcpcd.conf_old
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf_old

echo "Enlazando nuevos ficheros de configuración"
rm -rf /etc/dnsmasq.conf
ln -s /opt/AP-soft/configs/access_point/dnsmasq.conf /etc/dnsmasq.conf 2> /dev/null
#rm -rf /etc/dhcpcd.conf
#ln -s /opt/AP-soft/configs/access_point/dhcpcd.conf /etc/dhcpcd.conf 2> /dev/null
rm -rf /etc/hostapd/hostapd.conf
ln -s /opt/AP-soft/configs/access_point/hostapd.conf /etc/hostapd/hostapd.conf 2> /dev/null

echo "Habilitando cron"
systemctl enable cron.service
systemctl start cron.service

echo "Habilitando dnsmasq"
systemctl enable dnsmasq.service
systemctl start dnsmasq.service

echo "Habilitando hostapd"
systemctl enable hostapd.service
systemctl start hostapd.service

echo "Deshabilitando Apache2 por defecto"
systemctl disable apache2
systemctl stop apache2

cp -r /etc/network/interfaces.d /etc/network/interfaces.d_backup
rm -rf /etc/network/interfaces.d/*
cp /opt/AP-soft/configs/network_interfaces/* /etc/network/interfaces.d/


#echo "limpiando vhosts de Apache2 y cargando web de configuración del AP"
#cd /etc/apache2/sites-enabled && rm -rf ./*
#cd /etc/apache2/sites-available/ && rm -rf ./*
#cp /opt/AP-soft/templates/000-vhost.conf /etc/apache2/sites-available/000-vhost.conf
#/usr/sbin/a2ensite 000-vhost
#cd /var/www/html/ && rm -rf ./*
#cp /opt/AP-soft/templates/web_code/index.php /var/www/html/

#echo "Recargando configuración Apache2"
#systemctl reload apache2 2> /dev/null
#systemctl start apache2 2> /dev/null

echo "Cargando módulos udev para la detección de módem USB Huawei"
cp /opt/AP-soft/templates/udev_rules/40-huawei.rules /etc/udev/rules.d/

echo "Cargando configuración de crontab"
(crontab -l; echo "@reboot sleep 4 && /usr/sbin/rfkill unblock wlan && sleep 4 && systemctl restart hostapd") | sort -u | crontab -
(crontab -l; echo "* * * * * /usr/sbin/watchdog_vpn.sh") | sort -u | crontab -
(crontab -l; echo "@reboot /usr/sbin/iptables -t nat -A POSTROUTING -o usb0 -j MASQUERADE") | sort -u | crontab -


echo "Instalando flask"
pip3 install --break-system-packages  flask
pip3 install --break-system-packages  flask_basicauth



echo """
Últimos pasos manuales:
    - Debes cargar los credenciales VPN en /opt/AP-soft/configs/vpn/credentials.vpn
    - Debes cargar los perfiles .ovpn en el directorio /opt/AP-soft/configs/vpn/profiles/
    - Debes listar en el fichero /opt/AP-soft/configs/vpn/vpn_locations.conf los nombres de los perfiles que puedan utilizarse

Esto es todo :-)
"""