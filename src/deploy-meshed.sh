#!/bin/sh
echo "cat svc/nameapi.yaml | linkerd inject - | kubectl apply -f -"
cat svc/nameapi.yaml | linkerd inject - | kubectl apply -f -

echo "cat svc/helloworld.yaml | linkerd inject - | kubectl apply -f -"
cat svc/helloworld.yaml | linkerd inject - | kubectl apply -f -

echo "cat svc/goodbyeworld.yaml | linkerd inject - | kubectl apply -f -"
cat svc/goodbyeworld.yaml | linkerd inject - | kubectl apply -f -
