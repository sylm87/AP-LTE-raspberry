<?php


$file_dhcpcd = "/etc/dhcpcd.conf";
$file_dnsmasq = "/etc/dnsmasq.conf";
$file_hostapd = "/etc/hostapd/hostapd.conf";

function show_edition_file($file){
	$text = "";
	$myfile = fopen($file,"r");
	$text = fread($myfile,filesize($file));
?>
<textarea rows="40" cols="120">
<?php
echo $text;
?>
</textarea>
<?php
	fclose($myfile);
}


echo "<h1>Asistente de configuración enrutador VPN WiFi LTE (v0.1beta)</h1>";

if(isset($_GET["config"])) {
    $config = $_GET["config"];
    if($config == 'wifi') {
?>
<h2>Configuración HostAPd</h2>
<?php
show_edition_file($file_hostapd);
    } else if ($config == 'dhcp') {
?>
<h2>Configuración DHCPcd</h2>
<?php
show_edition_file($file_dhcpcd);
    } else if ($config == 'dns') {
?>
<h2>Configuración DNSmasq</h2>
<?php
show_edition_file($file_dnsmasq);
    }else if ($config == 'vpn') {
?>
<h2>Configuración VPN</h2>
<?php
    }
} else {
?>
<h2>Selecciona alguna de las configuraciones:<h2>
<ul>
<li><a href="/?config=wifi">WIFI</a></li>
<li><a href="/?config=dhcp">DHCP</a></li>
<li><a href="/?config=dns">DNS</a></li>
<li><a href="/?config=vpn">VPN</a></li>
</ul>
<?php
}
?>