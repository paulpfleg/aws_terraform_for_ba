#! /bin/bash
sudo hostnamectl set-hostname proxy;ls

sudo apt-get update;
sudo apt-get install nginx -y;

#unlink the default showcase host
sudo unlink /etc/nginx/sites-enabled/default;


#move to directory
sudo mv /home/ubuntu/nginx.conf /etc/nginx;

sudo nginx -s reload;
sudo systemctl restart nginx.service