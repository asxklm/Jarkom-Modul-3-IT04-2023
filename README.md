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
