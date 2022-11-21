#! /bin/bash
sudo hostnamectl set-hostname proxy;

sudo apt-get update;
sudo apt-get install --no-install-recommends software-properties-common;
sudo add-apt-repository ppa:vbernat/haproxy-2.5 -y;

sudo apt-get install nginx -y;
sudo apt-get install haproxy=2.5.\* -y;

# Move data from local to persist configs
mkdir ./uptime_kuma;
mv ./files/docker-compose.yml ./uptime_kuma/;
mv ./files/uptime-kuma-data ./uptime_kuma/;
chown -R ubuntu:ubuntu ./uptime_kuma/uptime-kuma-data;

#Install Docker & Docker Compose for Uptime Kuma
sudo snap install docker;

sudo groupadd docker;
#sudo usermod -aG docker "$USER";

#sudo systemctl enable docker.service;
#sudo systemctl enable containerd.service;
#sudo systemctl start docker;

#unlink the default showcase host
sudo unlink /etc/nginx/sites-enabled/default;

#move to directory
sudo mv /home/ubuntu/files/nginx.conf /etc/nginx;
sudo mv /home/ubuntu/files/haproxy.cfg /etc/haproxy;

rm -R /home/ubuntu/files;

cd /home/ubuntu/uptime_kuma || return;
sudo docker-compose up -d;

sudo nginx -s reload;

sudo systemctl daemon-reload;
sudo systemctl restart nginx.service;
sudo systemctl restart haproxy.service;


