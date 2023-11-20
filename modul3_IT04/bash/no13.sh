echo 'nameserver 192.235.1.2' > /etc/resolv.conf
apt-get update
apt-get install mariadb-server -y
service mysql start

# Lalu jangan lupa untuk mengganti [bind-address] pada file /etc/mysql/mariadb.conf.d/50-server.cnf menjadi 0.0.0.0 dan jangan lupa untuk melakukan restart mysql kembali

# Db akan diakses oleh 3 worker, maka 
echo '# This group is read both by the client and the server
# use it for options that affect everything
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

# Options affecting the MySQL server (mysqld)
[mysqld]
skip-networking=0
skip-bind-address
' > /etc/mysql/my.cnf

service mysql restart

mysql -u root -p
Enter password: 

CREATE USER 'kelompokit04'@'%' IDENTIFIED BY 'passwordit04';
CREATE USER 'kelompokit04'@'localhost' IDENTIFIED BY 'passwordit04';
CREATE DATABASE dbkelompokit04;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit04'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit04'@'localhost';
FLUSH PRIVILEGES;