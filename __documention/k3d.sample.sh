curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster test-cluster --api-port 6550 -p "8080:80@loadbalancer"

k3d cluster list
kubectl cluster-info

# build php docker image
docker build -t test-k3d:latest -f docker/php/Dockerfile .

# load php docker image into k3d cluster
k3d image import test-k3d:latest -c test-cluster

# check if image is loaded
kubectl get nodes -o wide


# delete pod and run it again if needed
kubectl delete pod test-container
kubectl run test-container --image=test-k3d:latest --restart=Never --image-pull-policy=Never
kubectl get pods


# kubectl describe node k3d-test-cluster-server-0 | grep "Container runtime"

# list images in k3d cluster
# kubectl get pods -A


# test wsl path
docker run --rm -v /var/www/html/k3d/src/php:/mnt/test alpine ls -al /mnt/test

# wsl2 chmod troubleshooting
sudo chmod -R 777 /var/www/html/k3d/src/php


# real deployment
kubectl delete pod test-container
kubectl apply -f k8s/manifests/

kubectl get services
kubectl get ingress


kubectl get pods --show-labels

kubectl get service php-service -o yaml | grep selector -A 2


kubectl get services -n kube-system | grep traefik

kubectl get endpoints -n kube-system | grep traefik

k3d cluster list



k3d cluster delete test-cluster
k3d cluster create test-cluster -p "80:80@loadbalancer" -p "443:443@loadbalancer"
k3d image import test-k3d:latest -c test-cluster
kubectl apply -f k8s/manifests/ingress.yaml
kubectl delete pod -n kube-system -l app.kubernetes.io/name=traefik






kubectl apply -f k8s/manifests/ingress.yaml
kubectl delete pod -n kube-system -l app.kubernetes.io/name=traefik

kubectl apply -f k8s/manifests/ingress.yaml

kubectl get endpoints php-service


kubectl exec -it $(kubectl get pod -l app=php -o jsonpath='{.items[0].metadata.name}') -- apachectl -S

kubectl exec -it $(kubectl get pod -l app=php -o jsonpath='{.items[0].metadata.name}') -- ls -al /var/www/html

kubectl describe pod -l app=php | grep -A5 "Volumes"
