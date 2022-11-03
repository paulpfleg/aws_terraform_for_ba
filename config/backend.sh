#! /bin/bash

sudo apt-get update;
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;


echo "instaling git now";
sudo apt-get install git -y;

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;

. ~/.nvm/nvm.sh;

nvm install --lts;

git clone https://github.com/paulpfleg/deploy.git;

cd ./deploy/express_api;
npm install;




