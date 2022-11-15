#!/bin/bash

declare -a arr=()

declare numOfIps=${num_backend}
declare numBackA=${num_backend_a}
declare numBackB=${num_backend_b}

cp config/proxy/files/nginx.template config/proxy/files/nginx.conf

for ((i=0;i<numBackA;i++))
do
    n=$((i+16))
  arr[i]="server 192.168.3."$n":8081 fail_timeout=60s;"
done


for ((i=0;i<numBackB;i++))
do
    n=$((i+16))
    m=$((i+numBackA))
  arr[m]="server 192.168.4."$n":8081 fail_timeout=60s;"
done


for ((i=0;i<numOfIps;i++))
do
  sed -i '' "/\#DYNAMIC_IPS/a\\
       $${arr[i]}" config/proxy/files/nginx.conf

    sed $'s/f/#DYNAMIC_IPS\\\n/' config/proxy/files/nginx.conf
done