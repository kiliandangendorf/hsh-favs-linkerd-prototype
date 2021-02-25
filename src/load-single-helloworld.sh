#!/bin/bash

service="helloworld"
#set url according to `minikube service list`
url="http://192.168.49.2:31223/${service}/"

for i in `seq 1 1000`;
do
    for j in `seq 1 4`;
    do
        curl -sL ${url}2
        echo
    done
done
