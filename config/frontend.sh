#! /bin/bash

sudo su;
hostname "frontend";
echo "frontende" > /etc/hostname;
su ubuntu;

sudo apt-get update;
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;
. ~/.nvm/nvm.sh;
nvm install node;

sudo apt-get isntall git -y;


