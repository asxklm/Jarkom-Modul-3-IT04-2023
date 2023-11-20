echo ' upstream worker {
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
} ' > /etc/nginx/sites-available/lb_php

service nginx restart