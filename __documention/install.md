## Create a k3d cluster

### delete the cluster (if needed)
```sh
k3d cluster delete test-cluster
```

### Create cluster if no k3d-cluster.yaml file
```sh
k3d cluster create test-cluster --servers 1 --agents 2 -p "80:80@loadbalancer" --volume /mnt/d/__wsl/k3d:/mnt/d/__wsl/k3d
```

### Create cluster if you have a k3d-cluster.yaml file
```sh
k3d cluster create --config k3d-cluster.yaml
```

### Import the image php image
```sh
k3d image import test-k3d:latest -c test-cluster
```

### Debug Get the nodes
```sh
kubectl get nodes -o wide
```


### Install Traefik
```sh
helm install traefik traefik/traefik \
  --namespace default \
  --set ports.websecure.tls.enabled=true \
  --set ingressClass.enabled=true \
  --set ingressClass.isDefaultClass=true \
  --set additionalArguments="{--certificatesresolvers.letsencrypt.acme.email=deljdlx@gmail.com,--certificatesresolvers.letsencrypt.acme.storage=/data/acme.json,--certificatesresolvers.letsencrypt.acme.httpChallenge.entryPoint=web}"
```

### Apply the php service and deployment
```sh
kubectl apply -f manifests/services/php/service.yaml
kubectl apply -f manifests/services/php/deployment.yaml
```

### Apply the ingressroute
```sh
kubectl apply -f manifests/base/noop-service.yaml
kubectl apply -f manifests/base/traefik-certresolver.yaml
kubectl logs -n default -l app.kubernetes.io/name=traefik -f
```

### apply the mariadb service and deployment
```sh
kubectl apply -f manifests/base/configmaps/mariadb-config.yaml
kubectl apply -f manifests/base/secrets/mariadb.yaml

kubectl apply -f manifests/services/mariadb/pv.yaml
kubectl apply -f manifests/services/mariadb/pvc.yaml
kubectl apply -f manifests/services/mariadb/service.yaml
kubectl apply -f manifests/services/mariadb/deployment.yaml
```


### populate the database with job faker-mysql-php
```sh
# if needed, docker build the image
docker build --no-cache -t faker-mysql-php -f docker/faker-mysql-php
docker tag faker-mysql-php k3d-test-cluster/faker-mysql-php

# import the image
k3d image import faker-mysql-php --cluster test-cluster

# apply the job
kubectl apply -f manifests/jobs/faker-mysql-php.yaml

# check the job logs
kubectl logs -l job-name=populate-mariadb

# connect to mysql with a temporary pod
kubectl run mysql-client --rm -it --image=mysql:latest -- bash
```