
helm show readme portainer/portainer

# Test Helm
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install busybox
helm install busybox-test bitnami/nginx --namespace default

# Check the pods
kubectl get pods -n default

# Test the service
kubectl exec -it $(kubectl get pod -l app.kubernetes.io/name=nginx -n default -o jsonpath="{.items[0].metadata.name}") -n default -- /bin/sh

# Uninstall busybox
helm uninstall busybox-test -n default

```

___
# Helm Charts - exemples with BusyBox DNS lookup

```bash
helm create helm/charts/dns-lookup
# delete unused files
# remove NOTES.txt ; why ? let's see later
helm template helm/charts/dns-lookup


helm install dns-test helm/charts/dns-lookup --namespace default

# Check the pods
kubectl get pods -n default


# Test the service
kubectl logs -n default -l app=dns-lookup --tail=10 --follow

# ???
helm upgrade dns-test helm/charts/dns-lookup --set lookupTarget="php-service.default.svc.cluster.local" --namespace default


```
# Helm Charts - exemples time http service

```bash

helm create helm/charts/http-time
# delete unused files ; keep deployment and ingress

helm template helm/charts/http-time


helm install http-time helm/charts/http-time --namespace default


# launch command on the pod
kubectl exec -it time-http-server-b8879d84-28c45 -- ls -l /

# sort this
kubectl get endpoints time-http-server -o yaml

helm uninstall http-time -n default

helm uninstall http-time -n default && helm install http-time helm/charts/http-time --namespace default

```



# dev-js chart

```bash
# build image
docker build -t dev-js:latest -f docker/dev-js/Dockerfile .

# test image
docker run --rm -it dev-js:latest bash

# test image with shared volume
docker run --rm -it -v $(pwd):/workspace dev-js:latest bash


helm create helm/charts/dev-js


helm lint helm/charts/dev-js
helm template helm/charts/dev-js
kubectl get pod -l app=dev-js -o jsonpath="{.items[0].spec.volumes}"





k3d image import dev-js:latest --cluster dev-cluster
helm upgrade --install dev-js helm/charts/dev-js

```

# Adminer chart

```bash
helm repo add cetic https://cetic.github.io/helm-charts
helm repo update
# helm install my-adminer cetic/adminer --set service.type=LoadBalancer
helm pull cetic/adminer --untar --destination helm/charts/
helm upgrade --install adminer helm/charts/adminer
helm uninstall adminer


# helm create helm/charts/phpmyadmin