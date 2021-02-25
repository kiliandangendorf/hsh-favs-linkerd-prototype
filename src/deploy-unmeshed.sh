#!/bin/sh
kubectl apply \
	-f svc/nameapi.yaml \
	-f svc/helloworld.yaml \
	-f svc/goodbyeworld.yaml 
