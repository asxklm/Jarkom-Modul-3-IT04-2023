echo 'upstream worker {
    server 192.235.4.1:8001;
    server 192.235.4.2:8002;
    server 192.235.4.3:8003;
}

server {
    listen 80;
    server_name riegel.canyon.it04.com www.riegel.canyon.it04.com;

    location / {
        proxy_pass http://worker;
    }
} 
' > /etc/nginx/sites-available/laravel-worker

ln -s /etc/nginx/sites-available/laravel-worker /etc/nginx/sites-enabled/laravel-worker

service nginx restart