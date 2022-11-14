#! /bin/bash
sudo hostnamectl set-hostname frontend;

sudo apt-get update;

echo "instaling git now";
sudo apt-get install git -y;

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;

. ~/.nvm/nvm.sh;

nvm install 18.12.1;

git clone git@github.com:paulpfleg/deploy.git;

cd ./deploy/aws_node || exit;
npm install;




