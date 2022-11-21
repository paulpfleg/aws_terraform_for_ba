#!/bin/bash

declare -a arr=()

declare numOfIps=${num_backend}
declare numBackA=${num_backend_a}
declare numBackB=${num_backend_b}

#rm config/proxy/files/haproxy.cfg;
cp config/proxy/files/haproxy.template config/proxy/files/haproxy.cfg;


for ((i=0;i<numBackA;i++))
do
    n=$((i+16))
  arr[i]="  server backend"$i" 192.168.3."$n":8081 check"
  
done


for ((i=0;i<numBackB;i++))
do
    n=$((i+16))
    m=$((i+numBackA))
  arr[m]="  server backend"$m" 192.168.4."$n":8081 check"
done


for ((i=0;i<numOfIps;i++))
do
#  sed -i '' "/\#DYNAMIC_IPS/a\\
#  \\
#$${arr[i]}" config/proxy/files/haproxy.cfg;

printf '%s\n' "$${arr[i]}" >> config/proxy/files/haproxy.cfg

done
