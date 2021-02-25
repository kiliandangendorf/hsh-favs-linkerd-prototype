#!/bin/sh
echo "cat svc/nameapi2.yaml | linkerd inject - | kubectl apply -f -"
cat svc/nameapi2.yaml | linkerd inject - | kubectl apply -f -

echo "kubectl apply -f svc/trafficsplit-90-10.yaml"
kubectl apply -f svc/trafficsplit-90-10.yaml
