# FAVS VPS

Short Documentation on how we setup our machine ([Installation](#installation)),  
how we connect to it via `ssh` ([Connect to VPS](#connect-to-vps)) and  
how we use Linkerd and see its work ([Inspect](#inspect)).


## Overview
- [FAVS VPS](#favs-vps)
  - [Overview](#overview)
  - [Inspect](#inspect)
    - [Use Linkerd](#use-linkerd)
    - [Install buggy demo app `emojivoto`](#install-buggy-demo-app-emojivoto)
    - [Building Docker Image for Minikube](#building-docker-image-for-minikube)
    - [Run K8s Job](#run-k8s-job)
  - [Connect to VPS](#connect-to-vps)
    - [`ssh` Hosts](#ssh-hosts)
    - [`ssh-copy-id`](#ssh-copy-id)
    - [Tunneling](#tunneling)
      - [Port-Forwarding](#port-forwarding)
      - [X11 Forwarding](#x11-forwarding)
  - [Installation](#installation)
    - [Pre Steps](#pre-steps)
      - [Add user `favs`](#add-user-favs)
      - [Change `ssh` Settings](#change-ssh-settings)
    - [Docker](#docker)
    - [Docker-Compose](#docker-compose)
    - [Post-installation Steps for Linux](#post-installation-steps-for-linux)
    - [Minikube](#minikube)
    - [`kubectl`](#kubectl)
    - [Firefox](#firefox)
    - [Linkerd](#linkerd)


## Inspect

Running `docker ps` gives a strange result on first sight:
Just _one_ container named `minikube`.
_Within_ is where the fun begins.
Run `docker ps` to inspect the container-id of minikube.
Then jump into with:
```
docker exec -it <cotainer-id> /bin/bash
```
Here it is where `docker ps` gives the expected result:  
18 Kubernetes container and 
27 Linkerd container (yes, 45 summed up).

You can easily get there by using:
```
minikube ssh
```

### Use Linkerd

Run the Dashboard:
```
linkerd dashboard
```
Since we use it headless, this command will throw one warning (never mind).
The Dashboards are there.
- Linkerd: http://localhost:50750  
- Grafana: http://localhost:50750/grafana  
	Grafana visualizes metrics collected by Prometheus.

This is where we use the [`ssh`-tunnel](#port-forwarding) again.
```
ssh -nNT -L 12345:127.0.0.1:50750 favs
```
And checkout locally:  
http://localhost:12345


### Install buggy demo app `emojivoto`

```
curl -sL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -
```

And it's already running! Check with:
```
kubectl -n emojivoto port-forward svc/web-svc 8080:80
```
(and for sure again the `ssh`-tunnel)

Now add Linkerd to this:
```
kubectl get -n emojivoto deploy -o yaml \
  | linkerd inject - \
  | kubectl apply -f -
```
First get manifest, then Linkerd adds annotations (the sidecars).
Kubernetes will perform a rolling deploy.

To see whats currently happening in namespace `emojivoto`:
```
linkerd -n emojivoto top deploy
```

To remove the `emojivoto` pods, give Kubernetes the manifest again but now with `delete` instead of `apply`:
```
curl -sL https://run.linkerd.io/emojivoto.yml | kubectl delete -f -
```

### Building Docker Image for Minikube

Here's a good explanation from Sergei on Medium: 
[How to Run Locally Built Docker Images in Kubernetes](https://medium.com/swlh/how-to-run-locally-built-docker-images-in-kubernetes-b28fbc32cc1d)

To build a Docker Image so that Minikube can use it, we need to run following command in every shell, we want to build:
```
eval $(minikube -p minikube docker-env)
```
After this command, we can build from Dockerfile as usual:
```
docker build . -t <nice-tag>
```
Now Kubernetes can find tagged image stated in manifest.

### Run K8s Job 

This is a spartan `manifest.yml`:
```
apiVersion: batch/v1
kind: Job
metadata:
  name: <fancy-name>
spec:
  template:
    metadata:
      name: <fancy-pod-name>
    spec:
      containers:
      - name: <fancy-container-name>
        image: <image-tag-from-above>
        imagePullPolicy: Never
      restartPolicy: Never
```
Since this image is build locally, we add the `imagePullPolicy` to `Never`.

Now we can run it injecting Linkerd in one with:
```
cat <config-yml> \
  | linkerd inject - \
  | kubectl apply -f -
```

To list local pods:
```
kubectl get pods
```

Find unique name and check logs:
```
kubectl logs <unique-pod-name>
```
If there are several belonging containers, you'll have to specify:
```
kubectl logs <unique-pod-name> <fancy-container-name>
```

This will remove the pod again:
```
kubectl delete -f <config-yml>
```

## Connect to VPS

Login:
```
IP:       64.227.126.210
User:     favs
PW:       YeahFAVS4
ssh-Port: 57128
```

Connect via:
```
ssh -p 57128 favs@64.227.126.210
```

### `ssh` Hosts
Easiest way here is to add a new `Host` in your `ssh`-config.
```
nano ~/.ssh/config
```
And add (somewhere) these lines:
```
Host favs
    Hostname 64.227.126.210
    Port 57128
    User favs
```

Now you will only have to type: 
```
ssh favs
```

### `ssh-copy-id`

To not always type your password for login, you can place your key remote for authentication.

If you already have a key-pair, copy your _public_ key with:
```
ssh-copy-id -i ~/.ssh/id_rsa.pub favs
```
If not, check how to generate one here: https://www.ssh.com/ssh/copy-id


### Tunneling

The Result of the following methods is equivalent. 
Choose one Port- or X11-Forwarding.

#### Port-Forwarding

Forward one local port to the remote VPS.
```
ssh -L <local_port>:<destination_server_ip>:<remote_port> <ssh_server_hostname>
```

For us this is:
```
ssh -nNT -L 12345:127.0.0.1:38055 favs
```
(The `-nNT` prevents the shell to be opened, since we only need the tunnel, not the remote shell.)

Ex. Run `linkerd dashboard &` on the VPS and you can access via:  
http://localhost:12345/

##### Use `LocalForward`
Optionally you can also configure the `ssh_config` for local forward:
```
Host favs
    Hostname 64.227.126.210
    Port 57128
    User favs
    LocalForward 12345 localhost:50750
```
When you use the shell (`ssh favs`) it will automatically build up the local port-forwarding.
If you start a second remote shell, there will be an info, that port is already bind (here: `12345`). 
This is not a problem since the tunnel is already established.


One slower alternative (but sometimes not avoidable) is the X11 Forwarding.

#### X11 Forwarding

Run Firefox on the VPS and get the rendered image via X11.
```
ssh -C -Y <user>@<hostname>:<ssh-port> "firefox"
```

Ex. Run `minikube dashboard` on the VPS and you can access via:
```
ssh -C -Y favs "firefox" "http://127.0.0.1:38055/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/"
```
(Minikube changing its dashboard-port every time it starts :/)

## Installation

What I have done so far from scratch on an Ubuntu 20.04...

### Pre Steps

Since our VPS is _online_ here's some security stuff...

#### Add user `favs`

and add to Sudoers:
```
adduser favs
usermod -aG sudo favs 
```
Password set to: YeahFAVS4 (Sudoers)

#### Change `ssh` Settings

Open
```
nano /etc/ssh/sshd_config
```
change Port
```
#Port 22 —> Port e.g. 57128
```

and disable `root` for ssh-login (since we have a sudo user already)
```
PermitRootLogin yes -> PermitRootLogin no
```

Apply with:
```
reboot
```

### Docker

Install Docker as it stated here: https://docs.docker.com/engine/install/ubuntu/
```
sudo apt-get update
sudo apt-get install -yq apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -yq docker-ce docker-ce-cli containerd.io
```
(Note the `-yq` options for `install` (assume yes and be quiet). It's pain trying to copy several lines of commands and `apt-get` aborts 'cause you didn't wrote "Y".)

### Docker-Compose

Now docker-compose: https://docs.docker.com/compose/install/
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
(We do not need docker-compose for our Service Mesh, but for testing it's helpful.)

### Post-installation Steps for Linux

Add `docker` to Sudoers:
```
sudo groupadd docker#if not already exists
sudo usermod -aG docker $USER
newgrp docker 
```
(https://docs.docker.com/engine/install/linux-postinstall/)

### Minikube 

Minikube should be enough for us. 
It runs lightweight and should be easy to learn Kubernetes.
Also Linkerd recommends it ;)

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
```
(https://minikube.sigs.k8s.io/docs/start/)

### `kubectl`

There is a `kubectl` within Minikube, but you'll always have to type several superfluous dashes what is _really_ annoying.
So lets just install it separate:
```
sudo snap install kubectl --classic
```

Check correct version (Linkerd needs 1.13 or above) with:
```
kubectl version --short
```

### Firefox

Needed for the X11 forwarding
```
sudo apt install firefox
```

### Linkerd

This part is accordingly to the official Tutorial: https://linkerd.io/2/getting-started/

Download and run install script for Linkerd-CLI
```
curl -sL https://run.linkerd.io/install | sh
```
and add to the `$PATH` environment:
```
export PATH=$PATH:$HOME/.linkerd2/bin
```
To make sure, this happens for every shell you run, put this into the `.bashrc`:
```
echo "export PATH=$PATH:$HOME/.linkerd2/bin" >> ~/.bashrc
```

Check if everything went well:
```
linkerd version
```
(Now this should return `Server version: unavailable` what's natch since Linkerd is not installed on the Kubernetes cluster yet.)

Validate cluster:
```
linkerd check --pre
```

Install Linkerd on cluster:
```
linkerd install | kubectl apply -f -
```

Validate installation:
```
linkerd check
```


### Bash-Completion

It is very useful to install bash-completion for the above installed programs.
Especially in `kubectl` you can compltete pod-names by pressing tab instead of typing huge pod-identifiers.

If bash-completion is not already installed:
```
apt-get install bash-completion
echo "source /etc/bash-completion" >> .bashrc 
```

To make completion available in every shell, we put each `source` command into the `.bashrc`.

**Linkerd**
```
echo "source <(linkerd completion bash)" >> .bashrc 
```
(For older bash or other OS check how to to with: `linkerd completion --help`)

**Minikube**
```
echo "source <(minikube completion bash)" >> .bashrc 
```
(For older bash or other OS check how to to with: `minikube completion --help`)

**kubectl**
```
echo "source <(kubectl completion bash)" >> .bashrc 
```
(For older bash or other OS check how to to with: `kubectl completion --help`)







