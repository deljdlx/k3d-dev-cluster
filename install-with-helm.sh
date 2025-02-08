# docker build -t dev-js:latest -f docker/adminer/Dockerfile .
# docker build -t code-server:latest -f docker/code-server/Dockerfile .
# docker build -t dev-js:latest -f docker/dev-js/Dockerfile .
# docker build -t dev-php:latest -f docker/dev-php/Dockerfile .
# docker build -t faker-mysql-php:latest -f docker/faker-mysql-php/Dockerfile .
# docker build -t pecule-api:latest -f docker/pecule-api/Dockerfile .


# sudo chmod 600 volumes/traefik-certificates/acme.json 


k3d cluster delete dev-cluster \
&& k3d cluster create --config cluster-config.yaml \
&& kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.3/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

# helm repo add grafana https://grafana.github.io/helm-charts
# helm repo add traefik https://traefik.github.io/charts
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo add portainer https://portainer.github.io/k8s
# helm repo update



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

# helm uninstall monitoring -n monitoring
helm dependency update helm/charts/_monitoring
helm upgrade --install monitoring helm/charts/_monitoring  -f helm/values-global.yaml \
--namespace monitoring --create-namespace

# ========================================================

helm install loki grafana/loki \
-n monitoring \
-f k8s/manifests/apps/loki/values.yaml

helm install promtail grafana/promtail -n monitoring


# ========================================================

# kubectl apply -f k8s/manifests/secrets/kibana.yaml
# kubectl apply -f k8s/manifests/apps/kibana/middlewares/basic-auth.yaml
# kubectl apply -f k8s/manifests/apps/kibana/ingress.yaml

sleep 10


echo "🔧 Install MariaDB"
kubectl apply -f k8s/manifests/apps/mariadb/pv.yaml \
&& kubectl apply -f k8s/manifests/secrets/mariadb.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/pvc.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/service.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/deployment.yaml



echo "🔧 Sleeping for 70 seconds, waiting for MariaDB"
sleep 120


echo "🔧 Import fake data into MariaDB"
k3d image import faker-mysql-php:latest --cluster dev-cluster \
&& kubectl apply -f k8s/manifests/secrets/mariadb.yaml \
&& kubectl apply -f k8s/manifests/jobs/faker-mysql-php.yaml \
&& sleep 10 \
&& kubectl logs -l job-name=populate-mariadb


echo "🔧 Import grafana data sources"
kubectl apply -f k8s/manifests/jobs/grafana-datasources.yaml


kubectl -n kubernetes-dashboard create token admin-user > volumes/src/informations/kubernetes-dashboard-token.txt




kubectl apply -f k8s/manifests/configmaps/pecule-api-config.yaml
helm upgrade --install pecule-api helm/private-charts/pecule-api -f helm/values-global.yaml



echo "💡 Kubernetes Dashboard Token:"
cat volumes/src/informations/kubernetes-dashboard-token.txt


kubectl get ingress -A | tail -n +2 | awk '{print $4}' > volumes/src/informations/ingress.txt
echo "💡 Ingress list :"
cat volumes/src/informations/ingress.txt


kubectl exec -it $(kubectl get pods | grep code-server | awk '{print $1}') -- cat /home/code-server/.config/code-server/config.yaml > volumes/src/informations/code-server-config.txt
echo "💡 Code Server Config :"
cat volumes/src/informations/code-server-config.txt





# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# sleep 40

# kubectl apply -f k8s/manifests/base/metalLb/metalLb.yaml
