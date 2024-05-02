#!/bin/bash

/usr/sbin/iptables -P INPUT ACCEPT
/usr/sbin/iptables -P OUTPUT ACCEPT
/usr/sbin/iptables -P FORWARD ACCEPT

/usr/sbin/iptables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
/usr/sbin/iptables -A INPUT -i wlan0 -m state --state ESTABLISHED,RELATED -j ACCEPT
/usr/sbin/iptables -A INPUT -i tun0 -m state --state ESTABLISHED,RELATED -j ACCEPT

/usr/sbin/iptables -A INPUT -i eth0 -p udp --dport 53 -j ACCEPT
/usr/sbin/iptables -A INPUT -i wlan0 -p udp --dport 53 -j ACCEPT # resolución DNS

/usr/sbin/iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
/usr/sbin/iptables -A INPUT -i wlan0 -p tcp --dport 22 -j ACCEPT # Gestión mediante SSH

/usr/sbin/iptables -A INPUT -i eth0 -p tcp --dport 5000 -j ACCEPT
/usr/sbin/iptables -A INPUT -i wlan0 -p tcp --dport 5000 -j ACCEPT # Panel gestor de configuración

/usr/sbin/iptables -A INPUT -i eth0 -j DROP
/usr/sbin/iptables -A INPUT -i wlan0 -j DROP
/usr/sbin/iptables -A INPUT -i tun0 -j DROP

/usr/sbin/iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE