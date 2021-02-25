#!/bin/bash

service="goodbyeworld"
#set url according to `minikube service list`
url="http://192.168.49.2:31223/${service}/"

for i in `seq 1 1000`;
do
    for j in `seq 1 4`;
    do
        if [ $# -eq 1 ]; then
            if [ $1 = "2" ]; then
                curl -sL "${url}${j}"
            fi
        else
            curl -sL ${url}
        fi
        echo
    done
done
