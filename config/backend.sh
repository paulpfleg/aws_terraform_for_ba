#! /bin/bash

sudo apt-get update;
export DEBIAN_FRONTEND=noninteractive;
sudo hostnamectl set-hostname backend;

echo "instaling git now";
sudo apt-get install git -y;

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;

. ~/.nvm/nvm.sh;

nvm install 18.12.1;

git clone git@github.com:paulpfleg/deploy.git;

cd ./deploy/express_api || exit;
mkdir input output;

npm install;

#sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade;
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ffmpeg;
sudo snap install ffmpeg;
