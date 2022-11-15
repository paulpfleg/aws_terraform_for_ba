#! /bin/bash
sudo hostnamectl set-hostname proxy;

sudo apt-get update;
sudo apt-get install nginx -y;


# Move data from local to persist configs
mkdir ./uptime_kuma;
mv ./files/docker-compose.yml ./uptime_kuma/;
mv ./files/uptime-kuma-data ./uptime_kuma/;
chown -R ubuntu:ubuntu ./uptime_kuma/uptime-kuma-data;

#Install Docker & Docker Compose for Uptime Kuma
sudo snap install docker;

sudo groupadd docker;
#sudo usermod -aG docker "$USER";
sudo systemctl enable docker.service;
sudo systemctl enable containerd.service;


#unlink the default showcase host
sudo unlink /etc/nginx/sites-enabled/default;

#move to directory
sudo mv /home/ubuntu/files/nginx.conf /etc/nginx;

rm -R ./files;

sudo nginx -s reload;

sudo systemctl daemon-reload;
sudo systemctl restart nginx.service;


cd ./uptime_kuma || return;
sudo docker-compose up -d;