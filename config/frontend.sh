#! /bin/bash

#change hostname of the server
sudo hostnamectl set-hostname frontend;

sudo apt-get update;

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
echo "aws_node" >> .git/info/sparse-checkout;

# choose the branch to pull
git pull origin develop;


cd ./aws_node || exit;

#install node dependencies
npm install;
