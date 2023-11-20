#!/bin/bash

echo 'nameserver 192.168.122.1' > /etc/resolv.conf
apt-get update
apt-get install bind9 -y  

echo 'zone "riegel.canyon.it04.com" {
	type master;
	file "/etc/bind/jarkom3/riegel.canyon.it04.com";
};

zone "granz.channel.it04.com" {
	type master;
	file "/etc/bind/jarkom3/granz.channel.it04.com";
};

zone "1.235.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom3/1.235.192.in-addr.arpa";
};
' > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom3
cp /etc/bind/db.local /etc/bind/jarkom3/riegel.canyon.it04.com
cp /etc/bind/db.local /etc/bind/jarkom3/granz.channel.it04.com
cp /etc/bind/db.local /etc/bind/jarkom3/1.235.192.in-addr.arpa

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     riegel.canyon.it04.com. root.riegel.canyon.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.it04.com.
@       IN      A       192.235.4.1     
www     IN      CNAME   riegel.canyon.it04.com.
' > /etc/bind/jarkom3/riegel.canyon.it04.com # IP Frieren

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     granz.channel.it04.com. root.granz.channel.it04.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                         2419200        ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.it04.com.
@       IN      A       192.235.3.1     
www     IN      CNAME   granz.channel.it04.com.
' > /etc/bind/jarkom3/granz.channel.it04.com # IP Lawine

echo 'options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;    # conform to RFC1035
      listen-on-v6 { any; };
}; ' > /etc/bind/named.conf.options

service bind9 restart