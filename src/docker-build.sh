#!/bin/sh
docker build --tag=microservice-linkerd-apache apache
docker build --tag=microservice-linkerd-goodbyeworld:1 goodbye-world-service
docker build --tag=microservice-linkerd-helloworld:1 hello-world-service
docker build --tag=microservice-linkerd-nameapi:1 name-service
