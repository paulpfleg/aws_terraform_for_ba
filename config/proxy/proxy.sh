#! /bin/bash
sudo hostnamectl set-hostname proxy;

sudo apt-get update;
sudo apt-get install --no-install-recommends software-properties-common -y;
sudo add-apt-repository ppa:vbernat/haproxy-2.5 -y;

sudo apt-get install nginx -y;
sudo apt-get install haproxy=2.5.\* -y;

# Move data from local to persist configs
mkdir ./uptime_kuma;
mv ./files/docker-compose.yml ./uptime_kuma/;
mv ./files/uptime-kuma-data ./uptime_kuma/;
chown -R ubuntu:ubuntu ./uptime_kuma/uptime-kuma-data;

#unlink the default showcase host
sudo unlink /etc/nginx/sites-enabled/default;

#move to directory
sudo mv /home/ubuntu/files/nginx.conf /etc/nginx;
sudo mv /home/ubuntu/files/haproxy.cfg /etc/haproxy;

rm -R /home/ubuntu/files;


sudo nginx -s reload;

#start the services
sudo systemctl daemon-reload;
sudo systemctl restart nginx.service;
sudo systemctl restart haproxy.service;


