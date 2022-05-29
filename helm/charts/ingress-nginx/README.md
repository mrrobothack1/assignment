# Ingress NGINX Controller

[ingress-nginx](https://github.com/kubernetes/ingress-nginx) Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer

To use, add the `kubernetes.io/ingress.class: nginx` annotation to your Ingress resources.

This chart bootstraps an ingress-nginx deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+

## Get Repo Info

```console
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

## Install Chart

```console
# Helm 3
$ helm install [RELEASE_NAME] ingress-nginx/ingress-nginx

# Helm 2
$ helm install --name [RELEASE_NAME] ingress-nginx/ingress-nginx
```

The command deploys ingress-nginx on the Kubernetes cluster in the default configuration.

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
# Helm 3
$ helm uninstall [RELEASE_NAME]

# Helm 2
# helm delete --purge [RELEASE_NAME]
```
