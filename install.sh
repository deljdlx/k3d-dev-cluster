#!/bin/bash

# change permission acme.json (letsencrypt certificates)
# sudo chmod 600 volumes/traefik-certificates/acme.json 




spinner() {
    pid=$1
    message=$2
    delay=0.1
    spin_chars="⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏"

    while kill -0 "$pid" 2>/dev/null; do
        for char in $spin_chars; do
            printf "\r%s %s" "$char" "$message"
            sleep "$delay"
        done
    done
    printf "\r✔️  %s\n" "$message"
}


echo "🔧 Building images..."

IMAGES="
adminer:docker/adminer/Dockerfile
code-server:docker/code-server/Dockerfile
dev-js:docker/dev-js/Dockerfile
dev-php:docker/dev-php/Dockerfile
faker-mysql-php:docker/faker-mysql-php/Dockerfile
pecule-api:docker-private/pecule-api/Dockerfile
"

for entry in $IMAGES; do
    IMAGE=$(echo "$entry" | cut -d':' -f1)
    DOCKERFILE=$(echo "$entry" | cut -d':' -f2)

    if [ -z "$(docker images -q "$IMAGE:latest")" ]; then
        echo "⚙️  Building $IMAGE..."
        docker build -t "$IMAGE:latest" -f "$DOCKERFILE" .
    else
        echo "👌 $IMAGE already exists, skipping build."
    fi
done



k3d cluster delete dev-cluster \
&& k3d cluster create --config cluster-config.yaml \
&& kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.3/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml


echo "🔧 add helm repo"

helm repo add grafana https://grafana.github.io/helm-charts
helm repo add traefik https://traefik.github.io/charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add portainer https://portainer.github.io/k8s
helm repo update



kubectl apply -f k8s/manifests/secrets/mariadb.yaml
kubectl apply -f k8s/manifests/configmaps/php-config.yaml

kubectl apply -f k8s/manifests/configmaps/traefik-config.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/role.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/account.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/role-binding.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/deployment.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/service.yaml\
&& kubectl apply -f k8s/manifests/apps/traefik-dashboard/service.yaml\
&& kubectl apply -f k8s/manifests/apps/traefik-dashboard/ingress.yaml


echo "🔧 import image faker-mysql-php"
k3d image import faker-mysql-php --cluster dev-cluster

echo "🔧 import image dev-php"
k3d image import dev-php:latest -c dev-cluster

echo "🔧 import image dev-js"
k3d image import dev-js:latest --cluster dev-cluster

echo "🔧 import image code-server"
k3d image import code-server:latest --cluster dev-cluster

echo "🔧 import image pecule-api"
k3d image import pecule-api:latest --cluster dev-cluster



echo "🔧 Install development charts"
helm dependency update helm/charts/_dev \
&& helm upgrade --install development helm/charts/_dev -f helm/values-global.yaml


echo "🔧 Install monitoring charts"
helm dependency update helm/charts/_monitoring
helm upgrade --install monitoring helm/charts/_monitoring  -f helm/values-global.yaml \
--namespace monitoring --create-namespace

# ========================================================
# todo overlay this
echo "🔧 Install loki"
helm install loki grafana/loki \
-n monitoring \
-f k8s/manifests/apps/loki/values.yaml

helm install promtail grafana/promtail -n monitoring

# ========================================================


# todo helmify this
echo "🔧 Install MariaDB"
kubectl apply -f k8s/manifests/apps/mariadb/pv.yaml \
&& kubectl apply -f k8s/manifests/secrets/mariadb.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/pvc.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/service.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/deployment.yaml




(sleep 120) &
spinner $! "🔧 Sleeping for 120 seconds, waiting for MariaDB"



echo "🔧 Import fake data into MariaDB"
k3d image import faker-mysql-php:latest --cluster dev-cluster \
&& kubectl apply -f k8s/manifests/secrets/mariadb.yaml \
&& kubectl apply -f k8s/manifests/jobs/faker-mysql-php.yaml


sleep 10
kubectl logs -l job-name=populate-mariadb


echo "🔧 Import grafana data sources"
kubectl apply -f k8s/manifests/jobs/grafana-datasources.yaml


kubectl -n kubernetes-dashboard create token admin-user > volumes/src/informations/kubernetes-dashboard-token.txt

echo "💡 Kubernetes Dashboard Token:"
cat volumes/src/informations/kubernetes-dashboard-token.txt


kubectl get ingress -A | tail -n +2 | awk '{print $4}' > volumes/src/informations/ingress.txt
echo "💡 Ingress list :"
cat volumes/src/informations/ingress.txt


kubectl exec -it $(kubectl get pods | grep code-server | awk '{print $1}') -- cat /home/code-server/.config/code-server/config.yaml > volumes/src/informations/code-server-config.txt
echo "💡 Code Server Config :"
cat volumes/src/informations/code-server-config.txt


# todo move this to a separate script
kubectl apply -f k8s/manifests/configmaps/pecule-api-config.yaml
helm upgrade --install pecule-api helm/private-charts/pecule-api -f helm/values-global.yaml



# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
# sleep 40
# kubectl apply -f k8s/manifests/base/metalLb/metalLb.yaml
