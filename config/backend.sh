#! /bin/bash

sudo apt-get update;

#prevent interactive mode when installing packages
export DEBIAN_FRONTEND=noninteractive;

#install git
sudo apt-get install git -y;

#download script to install nvm - node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;

#run it
. ~/.nvm/nvm.sh;

#install node js via nvm
nvm install 18.12.1;

mkdir deploy && cd deploy || return;

#add git. repo 
git init;
git remote add -f origin https://github.com/paulpfleg/deploy.git;

#add the folder, that should be checked out to the repo
git config core.sparseCheckout true;
echo "express_api" >> .git/info/sparse-checkout;

# choose the branch to pull
git pull origin develop;

cd ./express_api || exit;
mkdir input output;

#install node dependencies
npm install;

#install ffmpeg
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ffmpeg;
