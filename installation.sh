
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
apt-get remove -yq cupsd 2> /dev/null
apt-get -yq install \
dhcpcd \
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
git

echo "Creando directorio base en /opt y cargando ficheros de configuración"
mkdir -p /opt/AP-soft/

cp -r ./configs /opt/AP-soft/
cp -r ./templates /opt/AP-soft/
chmod +x /opt/AP-soft/configs/vpn/watchdog_vpn.sh
ln -s /opt/AP-soft/configs/vpn/watchdog_vpn.sh /sbin/watchdog_vpn.sh

echo "Sustituyendo ficheros de configuración originales"
mv /etc/dnsmasq.conf /etc/dnsmasq.conf_old 
mv /etc/dhcpcd.conf /etc/dhcpcd.conf_old
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf_old

echo "Enlazando nuevos ficheros de configuración"
ln -s /opt/AP-soft/configs/access_point/dnsmasq.conf /etc/dnsmasq.conf
ln -s /opt/AP-soft/configs/access_point/dhcpcd.conf /etc/dhcpcd.conf
ln -s /opt/AP-soft/configs/access_point/hostapd.conf /etc/hostapd/hostapd.conf

echo "Habilitando cron"
systemctl enable cron.service
systemctl start cron.servicels -ls

echo "Deshabilitando Apache2 por defecto"
systemctl disable apache2
systemctl stop apache2

echo "limpiando vhosts de Apache2 y cargando web de configuración del AP"
cd /etc/apache2/sites-enabled && rm -rf ./*
cd /etc/apache2/sites-available/ && rm -rf ./*
cp /opt/AP-soft/templates/000-vhost.conf /etc/apache2/sites-available/000-vhost.conf
/usr/sbin/a2ensite 000-vhost
cd /var/www/html/ && rm -rf ./*
cp /opt/AP-soft/templates/web_code/index.php /var/www/html/

echo "Recargando configuración Apache2"
systemctl reload apache2 2> /dev/null

echo "Cargando módulos udev para la detección de módem USB Huawei"
cp /opt/AP-soft/templates/udev_rules/40-huawei.rules /etc/udev/rules.d/

echo "Cargando configuración de crontab"
(crontab -l; echo "@reboot sleep 4 && /usr/sbin/rfkill unblock wlan && sleep 4 && systemctl restart hostapd") | sort -u | crontab -
(crontab -l; echo "* * * * * /usr/sbin/watchdog_vpn.sh") | sort -u | crontab -

echo """
Últimos pasos manuales:
    - Debes cargar los credenciales VPN en /opt/AP-soft/configs/vpn/credentials.vpn
    - Debes cargar los perfiles .ovpn en el directorio /opt/AP-soft/configs/vpn/profiles/
    - Debes listar en el fichero /opt/AP-soft/configs/vpn/vpn_locations.conf los nombres de los perfiles que puedan utilizarse

Esto es todo :-)
"""