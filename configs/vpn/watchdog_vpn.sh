#!/bin/bash

# Comprobamos primero si hay Internet...
if ping -c1 google.com &>/dev/null;
then
        echo "Tienes Internet. Ok, continuamos...";
else
        echo "No tienes conexion, abortamos";
        exit 1;
fi


vpn_locations_file_conf="/opt/AP-soft/configs/vpn/vpn_locations.conf"
vpn_credentials_conf="/opt/AP-soft/configs/vpn/credentials.vpn"
vpn_profiles_dir="/opt/AP-soft/configs/vpn/profiles/"

pid_openvpn_process=$(ps --no-headers -C openvpn | xargs | cut -d " " -f 1)
if [[ $pid_openvpn_process == "" ]]
then
    echo "No hay conexión OpenVPN, la levantamos!"
    # pillamos un profile aleatorio de los habilitados
    random_vpn_location=$(shuf -n 1 ${vpn_locations_file_conf})
    # levantamos la VPN
    cd ${vpn_profiles_dir} && nohup /usr/sbin/openvpn --config ${random_vpn_location} --auth-user-pass ${vpn_credentials_conf} &
    exit 0
fi
echo "Actualmente existe un OpenVPN corriendo, lo ignoramos..."


