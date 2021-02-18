# How to use Linkerd/Kubectl

[Quelle](https://m.heise.de/developer/artikel/Alle-11-Minuten-verliebt-sich-ein-Microservice-in-Linkerd-4511406.html?seite=all)



## Overview
- [Intro](#Intro)

## Intro

## Kubectl
Show all Pods
```
kubectl get pods
```
Show all services in namespace "linkerd"
```
kubectl get services -n linkerd
```
[Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) are logical organisation components. 
Show all namespaces in kubectl
```
kubectl get namespace
```
[Annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) are metadate can be used by tools and libs.
Inject all defined services (sidecars).
```
kubectl annotate namespace default linkerd.io/inject=enabled
```

install:
- helm, a package manager for kubernetes:
- traefik, reverse proxe zum umleiten von datenströmen
```
sudo snap install helm --classic
#helm repo add stable https://charts.helm.sh/stable
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
kubectl create namespace traefik
helm install --set --namespace=traefik traefik traefik/traefik
```

java+maven
```
sudo apt install openjdk-11-jdk
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >> ~/.bashrc 
sudo apt install maven
mvn -N io.takari:maven:wrapper
```

connect Docker-cli with docker inside minicube.
```
eval $(minikube -p minikube docker-env)
```

show logs from service:
```
kubectl logs order-cc7f8866-9zbnf order 
```


minikube show url from service

```
minikube service apache --url
```


## Linkerd
Check Linkerd
```
linkerd check
```
