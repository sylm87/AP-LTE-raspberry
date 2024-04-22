<?php
echo "Asistente de configuración enrutador VPN WiFi LTE (v0.1beta)";

if(isset($_GET["config"])) {
    $config = $_GET["config"];
    if($config == 'wifi') {
        echo "Configuración HostAPd";
    } else if ($config == 'dhcp') {
        echo "Configuración DHCPcd";
    } else if ($config == 'dns') {
        echo "Configuración DNSmasq";
    }else if ($config == 'vpn') {
        echo "Configuración VPN";
    }else{
        echo "Selecciona alguna de las configuraciones:";
    }
  }

?>