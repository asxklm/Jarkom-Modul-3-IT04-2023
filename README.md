# Jarkom Modul 3 IT04 2023
- Kevin Putra Santoso (5027211030)
- Bagus Cahyo Arrasyid (5027211033)

## Soal 0
> Lakukan konfigurasi sesuai dengan Topologi yang sudah diberikan.
### Topologi
![Screenshot 2023-11-20 143354](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/6adf4d4c-3a5b-42f5-b22a-15176758edf2)

### Network Configuration
#### Aura (DHCP Relay)
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.235.1.0
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.235.2.0
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.235.3.0
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.235.4.0
	netmask 255.255.255.0

```
#### Himmel (DHCP Server)
```
auto eth0
iface eth0 inet static
	address 192.235.1.1
	netmask 255.255.255.0
	gateway 192.235.1.0

```
#### Heiter (DNS Server)
```
auto eth0
iface eth0 inet static
	address 192.235.1.2
	netmask 255.255.255.0
	gateway 192.235.1.0
```
#### Denken (Database Server)
```
auto eth0
iface eth0 inet static
	address 192.235.2.1
	netmask 255.255.255.0
	gateway 192.235.2.0
```
#### Eisen (Load Balancer)
```
auto eth0
iface eth0 inet static
	address 192.235.2.2
	netmask 255.255.255.0
	gateway 192.235.2.0
```
#### Frieren (Laravel Worker)
```
auto eth0
iface eth0 inet static
	address 192.235.4.3
	netmask 255.255.255.0
	gateway 192.235.4.0
```
#### Flamme (Laravel Worker)
```
auto eth0
iface eth0 inet static
	address 192.235.4.2
	netmask 255.255.255.0
	gateway 192.235.4.0
```
#### Fern (Laravel Worker)
```
auto eth0
iface eth0 inet static
	address 192.235.4.1
	netmask 255.255.255.0
	gateway 192.235.4.0
```
#### Lawine (PHP Worker)
```
auto eth0
iface eth0 inet static
	address 192.235.3.3
	netmask 255.255.255.0
	gateway 192.235.3.0
```
#### Linie (PHP Worker)
```
auto eth0
iface eth0 inet static
	address 192.235.3.2
	netmask 255.255.255.0
	gateway 192.235.3.0
```
#### Lugner (PHP Worker)
```
auto eth0
iface eth0 inet static
	address 192.235.3.1
	netmask 255.255.255.0
	gateway 192.235.3.0
```
#### Revolte, Richter, Sein, dan Stark (Client)
```
auto eth0
iface eth0 inet dhcp
```
### Enable Internet Access
Agar setiap node dalam jaringan dapat mengakses internet melalui NAT, maka digunakan command berikut pada Router:
```bash
# enable all nodes to access internet
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.235.0.0/16
```
## Soal 1
> Kali ini, kalian diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP (0) mengarah pada worker yang memiliki IP [prefix IP].x.1.
### Setup Heiter (DNS Server)
1. Install depedencies
```bash
echo 'nameserver 192.168.122.1' > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
```
2. Membuat direktori dan copy default config untuk diedit
```
mkdir /etc/bind/jarkom3
cp /etc/bind/db.local /etc/bind/jarkom3/riegel.canyon.it04.com
cp /etc/bind/db.local /etc/bind/jarkom3/granz.channel.it04.com
```
3. Pada file `/etc/bind/named.conf.local` tambahkan line berikut:
```
zone "riegel.canyon.it04.com" {
	type master;
	file "/etc/bind/jarkom3/riegel.canyon.it04.com";
};

zone "granz.channel.it04.com" {
	type master;
	file "/etc/bind/jarkom3/granz.channel.it04.com";
};
```
4. Pada file `/etc/bind/jarkom3/riegel.canyon.it04.com` tambahkan line berikut:
```
;
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
```
5. Pada file `/etc/bind/jarkom3/granz.channel.it04.com` tambahkan line berikut:
```
;
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
```
6. Lakukan `service bind9 start` pada Heiter
### Result
Test pada node dengan `ping riegel.canyon.it04.com` atau `ping granz.channel.it04.com` 

![Screenshot 2023-11-20 123423](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/bac584df-d0e3-48e7-a564-0c6fdf0eaece)

## Soal 2
> Semua CLIENT harus menggunakan konfigurasi dari DHCP Server. Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80
### Himmel (DHCP Server)
1. Install depedencies dan Pastikan DNS Server sudah berjalan 
```bash
echo 'nameserver 192.235.1.2' > /etc/resolv.conf   
apt-get update
apt install isc-dhcp-server -y
```
2. Pada file `/etc/dhcp/dhcpd.conf` tambahkan line berikut:
```
subnet 192.235.1.0 netmask 255.255.255.0 {
}

subnet 192.235.2.0 netmask 255.255.255.0 {
}

subnet 192.235.3.0 netmask 255.255.255.0 {
    range 192.235.3.16 192.235.3.32;
    range 192.235.3.64 192.235.3.80;
    option routers 192.235.3.0;
}
```

## Soal 3
> Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168
### Himmel (DHCP Server)
1. Pada file `/etc/dhcp/dhcpd.conf` tambahkan config switch4 menjadi berikut:
```
subnet 192.235.1.0 netmask 255.255.255.0 {
}

subnet 192.235.2.0 netmask 255.255.255.0 {
}

subnet 192.235.3.0 netmask 255.255.255.0 {
    range 192.235.3.16 192.235.3.32;
    range 192.235.3.64 192.235.3.80;
    option routers 192.235.3.0;
}

subnet 192.235.4.0 netmask 255.255.255.0 {
    range 192.235.4.12 192.235.4.20;
    range 192.235.4.160 192.235.4.168;
    option routers 192.235.4.0;
}
```

## Soal 4
> Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut
### Himmel (DHCP Server)
1. Menambahkan beberapa konfigurasi `option broadcast-address` dan `option domain-name-server` pada file `/etc/dhcp/dhcpd.conf` agar terhubung dengan internet melalui DNS
```
subnet 192.235.1.0 netmask 255.255.255.0 {
}

subnet 192.235.2.0 netmask 255.255.255.0 {
}

subnet 192.235.3.0 netmask 255.255.255.0 {
    range 192.235.3.16 192.235.3.32;
    range 192.235.3.64 192.235.3.80;
    option routers 192.235.3.0;
    option broadcast-address 192.235.3.255;
    option domain-name-servers 192.235.1.2;
}

subnet 192.235.4.0 netmask 255.255.255.0 {
    range 192.235.4.12 192.235.4.20;
    range 192.235.4.160 192.235.4.168;
    option routers 192.235.4.0;
    option broadcast-address 192.235.4.255;
    option domain-name-servers 192.235.1.2;
}
```
2. Lakukan `service isc-dhcp-server start` pada Himmel

### Aura (DHCP Relay)
1. Install depedencies dan Pastikan DNS Server sudah berjalan 
```bash
apt-get update
apt install isc-dhcp-relay -y
```
2. Menambahkan beberapa konfigurasi pada file `/etc/default/isc-dhcp-relay` agar terhubung dengan internet melalui DHCP Server
```
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="192.235.1.1"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3 eth4"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""
```
3. Lakukan `service isc-dhcp-relay start` pada Aura

### Client 
1. Install depedencies dan Pastikan DNS Server sudah berjalan 
```bash
apt update
apt install lynx -y
apt install htop -y
apt install apache2-utils -y
apt-get install jq -y
```

### Result
Test pada node client dengan `ping riegel.canyon.it04.com` atau `ping granz.channel.it04.com` atau `ping google.com`

![Screenshot 2023-11-20 124146](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/c5a4b2c4-ffd0-422c-b0d6-e82ab6235f41)

## Soal 5
> Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit
### Himmel (DHCP Server)
1. Menambahkan beberapa konfigurasi `default-lease-time` dan `max-lease-time` pada file `/etc/dhcp/dhcpd.conf` untuk waktu maksimal peminjaman alamat IP
```
subnet 192.235.1.0 netmask 255.255.255.0 {
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
}
```
2. Lakukan `service isc-dhcp-server restart` pada Himmel

### Result
Test pada node client dengan switch3 dan swith4

![Screenshot 2023-11-20 124231](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/63f0c1c6-1ae1-4044-91e4-ca2d105938a5)

![Screenshot 2023-11-20 124243](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/7ce7454e-937a-4c23-8028-cf739a1437ba)

## Soal 6
> Pada masing-masing worker PHP, lakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3.
### Lawine, Linie, dan Lugner (PHP Worker)
1. Install depedencies dan Pastikan DNS Server sudah berjalan 
```bash
echo 'nameserver 192.235.1.2' > /etc/resolv.conf
apt-get update
apt-get install nginx -y
apt-get install wget -y
apt-get install unzip -y
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip -y
```
2. Lakukan download `https://drive.google.com/u/0/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download` 
```
wget -O '/var/www/granz.channel.it04.com' 'https://drive.google.com/u/0/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download'
unzip -o /var/www/granz.channel.it04.com -d /var/www/
rm /var/www/granz.channel.it04.com
mv /var/www/modul-3 /var/www/granz.channel.it04.com
```
3. Lakukan menyalin konfig `/etc/nginx/sites-available/default` yang akan diubah menjadi `granz.channel.it04.com`
```
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/granz.channel.it04.com
ln -s /etc/nginx/sites-available/granz.channel.it04.com /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
```
4. Ubah konfig file granz pada `/etc/nginx/sites-available/granz.channel.it04.com` menjadi berikut
```
server {
    listen 80;
    server_name _;

    root /var/www/granz.channel.it04.com;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;  # Sesuaikan versi PHP dan socket
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```
5. Lakukan `service nginx start` pada PHP Worker

### Result
Test pada node PHP Worker dengan `lynx localhost`

![Screenshot 2023-11-20 124549](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/e4429634-0bc6-4a75-be89-96516b5e103c)

## Soal 7
> Aturlah agar Eisen dapat bekerja dengan maksimal, lalu lakukan testing dengan 1000 request dan 100 request/second
### Eisen (Load Balancer)
1. Install depedencies dan Pastikan DNS Server sudah berjalan 
```bash
echo 'nameserver 192.235.1.2' > /etc/resolv.conf
apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y
```
2. Lakukan menyalin konfig `/etc/nginx/sites-available/default` yang akan diubah menjadi `/etc/nginx/sites-available/lb_php`
```bash
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb_php
ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
```
3. Ubah konfig file granz pada `/etc/nginx/sites-available/lb_php` menjadi berikut
```
upstream worker {
    server 192.235.3.1;
    server 192.235.3.2;
    server 192.235.3.3;
}

server {
    listen 80;
    server_name granz.channel.it04.com www.granz.channel.it04.com;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        proxy_pass http://worker;
    }
}
```
4. Lakukan `service nginx start` pada LB Eisen

### Eisen (Load Balancer)
Buka kembali Node DNS Server dan arahkan domain tersebut pada `IP Load Balancer Eisen`

### Result
Test pada node PHP Worker dengan `lynx localhost`

![Screenshot 2023-11-20 125007](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/7cb47bfa-80d2-458b-b940-1f3b6f52c1c1)

## Soal 8
> Karena diminta untuk menuliskan grimoire, buatlah analisis hasil testing dengan 200 request dan 10 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut

Jawaban Disini [link](https://docs.google.com/document/d/1DNSblLYthJWyU10nlxLcPAAO8yeqI6MySAF3uXMYNTA/edit?usp=sharing)

## Soal 9
> Dengan menggunakan algoritma Round Robin, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 100 request dengan 10 request/second, kemudian tambahkan grafiknya pada grimoire

Jawaban Disini [link](https://docs.google.com/document/d/1DNSblLYthJWyU10nlxLcPAAO8yeqI6MySAF3uXMYNTA/edit?usp=sharing)

## Soal 10
> Selanjutnya coba tambahkan konfigurasi autentikasi di LB dengan dengan kombinasi username: “netics” dan password: “ajkyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/rahasisakita/
### Eisen (Load Balancer)
1. Membuat file bash untuk membuat direktori dan file htpasswd
```
mkdir /etc/nginx/rahasisakita
htpasswd -c /etc/nginx/rahasisakita/htpasswd netics
```
2. Melakukan update konfig file `/etc/nginx/sites-available/lb_php`
```
upstream worker {
    server 192.235.3.1;
    server 192.235.3.2;
    server 192.235.3.3;
}

server {
    listen 80;
    server_name granz.channel.it04.com www.granz.channel.it04.com;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        proxy_pass http://worker;
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
    }
}
```
3. Melakukan `service nginx restart` pada LB Eisen

### Result
Test pada node Client dengan `lynx localhost`

![Screenshot 2023-11-20 131048](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/5a85a160-19c5-466d-abce-56825137be08)

![Screenshot 2023-11-20 131058](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/34144559-e495-4a6a-b1a6-9ac1b0ba9542)

## Soal 11
> Lalu buat untuk setiap request yang mengandung /its akan di proxy passing menuju halaman https://www.its.ac.id
### Eisen (Load Balancer)
1. Melakukan update `Proxy Header` agar meneruskan ke web ITS konfig file `/etc/nginx/sites-available/lb_php`
```
upstream worker {
    server 192.235.3.1;
    server 192.235.3.2;
    server 192.235.3.3;
}

server {
    listen 80;
    server_name granz.channel.it04.com www.granz.channel.it04.com;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://worker;
    }

    location ~ /its {
        proxy_pass https://www.its.ac.id;
        proxy_set_header Host www.its.ac.id;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
2. Melakukan `service nginx restart` pada LB Eisen

### Result
Test pada node Client dengan `lynx localhost`

![Screenshot 2023-11-20 131528](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/2e47d46a-9656-4cbd-bea6-58f71de52a62)

## Soal 12
> Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].3.69, [Prefix IP].3.70, [Prefix IP].4.167, dan [Prefix IP].4.168
### Eisen (Load Balancer)
1. Melakukan update `Proxy Pass` agar meneruskan ke web granz pada konfig file `/etc/nginx/sites-available/lb_php`
```
upstream worker {
    server 192.235.3.1;
    server 192.235.3.2;
    server 192.235.3.3;
}

server {
    listen 80;
    server_name granz.channel.it04.com www.granz.channel.it04.com;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    location / {
        allow 192.235.3.69;
        allow 192.235.3.70;
        allow 192.235.4.167;
        allow 192.235.4.168;
        deny all;
        proxy_pass http://worker;
    }

    location ~ /its {
        proxy_pass https://www.its.ac.id;
        proxy_set_header Host www.its.ac.id;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
2. Melakukan `service nginx restart` pada LB Eisen

### Result
Test pada node Client dengan `lynx localhost` tetapi harus melakukan fix IP manual melalui config node GNS3

![Screenshot 2023-11-20 131105](https://github.com/asxklm/Jarkom-Modul-3-IT04-2023/assets/113827418/e8ff91f0-bd34-4ff9-8d49-088915f6b2c0)

## Soal 13
> Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern
### Denken (Database Server)
