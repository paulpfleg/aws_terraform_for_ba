#! /bin/bash

sudo apt-get update;
export DEBIAN_FRONTEND=noninteractive;

echo "instaling git now";
sudo apt-get install git -y;

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;

. ~/.nvm/nvm.sh;

nvm install 18.12.1;

mkdir deploy && cd deploy || return;

git init;
git remote add -f origin https://github.com/paulpfleg/deploy.git;
git config core.sparseCheckout true;
echo "express_api" >> .git/info/sparse-checkout;
git pull origin main;

cd ./express_api || exit;
mkdir input output;

npm install;

#sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade;
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ffmpeg;
sudo snap install ffmpeg;
