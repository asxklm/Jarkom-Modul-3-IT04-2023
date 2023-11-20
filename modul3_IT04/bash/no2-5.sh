#!/bin/bash

echo 'nameserver 192.235.1.2' > /etc/resolv.conf   # Pastikan DNS Server sudah berjalan 
apt-get update
apt install isc-dhcp-server -y

echo 'subnet 192.235.1.0 netmask 255.255.255.0 {
}

subnet 192.235.2.0 netmask 255.255.255.0 {
}

subnet 192.235.3.0 netmask 255.255.255.0 {
    range 192.235.3.16 192.235.3.32;
    range 192.235.3.64 192.235.3.80;
    option routers 192.235.3.0;
    option broadcast-address 192.235.3.255;
    option domain-name-servers 192.235.1.2;
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 192.235.4.0 netmask 255.255.255.0 {
    range 192.235.4.12 192.235.4.20;
    range 192.235.4.160 192.235.4.168;
    option routers 192.235.4.0;
    option broadcast-address 192.235.4.255;
    option domain-name-servers 192.235.1.2;
    default-lease-time 720;
    max-lease-time 5760;
} ' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server start

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf