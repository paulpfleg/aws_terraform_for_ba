#!/bin/bash

#shell script to dynamicly configure nginx config file

declare -a arr=()

#variable declaration
#variables are handed over by terraform
declare numOfIps=${num_backend}
declare numBackA=${num_backend_a}
declare numBackB=${num_backend_b}


cp config/proxy/files/haproxy.template config/proxy/files/haproxy.cfg;


# fill array with strings containing ips of AVZ_A
for ((i=0;i<numBackA;i++))
do
    n=$((i+16))
  arr[i]="  server backend"$i" 192.168.3."$n":8081 check"
  
done


# fill array with strings containing ips of AVZ_B
for ((i=0;i<numBackB;i++))
do
    n=$((i+16))
    m=$((i+numBackA))
  arr[m]="  server backend"$m" 192.168.4."$n":8081 check"
done

#print the content of the array to the config file
for ((i=0;i<numOfIps;i++))
do
printf '%s\n' "$${arr[i]}" >> config/proxy/files/haproxy.cfg

done
