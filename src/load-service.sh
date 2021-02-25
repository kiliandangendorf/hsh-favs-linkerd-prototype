#!/bin/bash

#set url according to `minikube service list`
url="http://192.168.49.2:31223/"

for i in `seq 1 1000`;
do
    curl -sL ${url}$1
    echo
done