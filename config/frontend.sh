#! /bin/bash

sudo apt-get update;
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash;

sudo apt-get install git -y;

git clone https://github.com/paulpfleg/deploy.git;

. ~/.nvm/nvm.sh
nvm install node
echo "----installed node!-----";



# sudo . ~/.nvm/nvm.sh;



