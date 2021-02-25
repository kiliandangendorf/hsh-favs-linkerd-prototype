#!/bin/bash

echo "delete deployments and services"
kubectl delete \
	-f svc/nameapi.yaml \
	-f svc/nameapi2.yaml \
	-f svc/helloworld.yaml \
	-f svc/goodbyeworld.yaml

echo "delete trafficsplit"
kubectl delete \
	trafficsplits.split.smi-spec.io \
	nameapi-split
