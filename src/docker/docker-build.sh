#!/bin/sh
eval $(minikube -p minikube docker-env)

docker build --tag=microservice-linkerd-goodbyeworld:1 goodbyeworld
docker build --tag=microservice-linkerd-helloworld:1 helloworld
docker build --tag=microservice-linkerd-nameapi:1 nameapi
docker build --tag=microservice-linkerd-nameapi:2 nameapi2
