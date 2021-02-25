# Demo sources

## Showcases
1. Cluster without Service Mesh (no TLS)
2. Add Services to Service Mesh (TLS)
3. Load Balancing between Replicas
4. Add 90/10 Traffic Split

## Usage

...and corresponding scripts and files.

1. Cluster without Service Mesh (no TLS)
	1. `sh deploy-unmeshed.sh`
    2. See Linkerd dashboard (`linkerd dashboard` and `ssh -nNT -L 12345:127.0.0.1:50750 favs`)
    3. Show service in browser (`ssh -nNT -L 12346:192.168.49.2:31223 favs`)
2. Add Services to Service Mesh (TLS)
    1. `sh deploy-meshed.sh`
    2. `sh load-helloworld.sh`
    3. in second window show: `linkerd tap deploy/helloworld` see `tls=true`
    4. Reload Linkerd dashboard to see plotted graph
3. Load Balancing between Replicas
    1. `sh load-goodbyeworld.sh`
    2. Click on `goddbyewordl`-service in Linkerd dashboard
    3. Scroll down to pods to see balanced load
4. Add 90/10 Traffic Split
    1. `sh deploy-nameapi-v2.sh` does to things
        1. creates service `nameapi-v2`
        2. applies traffic-split-route
    2. See Trafic Split shown in Linkerd dashboard. 
    With a click on it dashboard will show the weights of the traffic split.
    3. `sh load-single-helloworld.sh` (to see differences between versions better)
    4. Linkerd dashboard click on `helloworld`
    5. Shown graph has two edges from `helloworld` to `nameapi` *and* `nameapi-v2`

Use `sh cleanup.sh` to delete all services and traffic splits above.

## Explanations
- Prometeheus & Grafana for Monitoring 
- soemthing about the files in `svc`
- soemthing about the files in `docker`
	- Note: use `eval $(minikube -p minikube docker-env)`