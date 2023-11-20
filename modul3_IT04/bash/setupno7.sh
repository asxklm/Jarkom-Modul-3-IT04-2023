#!/bin/bash

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     riegel.canyon.it04.com. root.riegel.canyon.it04.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.it04.com.
@       IN      A       192.235.2.2     ; IP LB Eiken
www     IN      CNAME   riegel.canyon.it04.com.' > /etc/bind/jarkom3/riegel.canyon.it04.com

echo '
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     granz.channel.it04.com. root.granz.channel.it04.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.it04.com.
@       IN      A       192.235.2.2     ; IP LB Eiken
www     IN      CNAME   granz.channel.it04.com.' > /etc/bind/jarkom3/granz.channel.it04.com

service bind9 restart