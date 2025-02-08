
echo 🟢 Initializing cluster
k3d cluster delete dev-cluster \
&& k3d cluster create --config cluster-config.yaml \
&& kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.3/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml


echo 🟢 Configure traefik and traefik dashboard
kubectl apply -f k8s/manifests/configmaps/traefik-config.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/role.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/account.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/role-binding.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/deployment.yaml \
&& kubectl apply -f k8s/manifests/base/traefik/service.yaml\
&& kubectl apply -f k8s/manifests/apps/traefik-dashboard/service.yaml \
&& kubectl apply -f k8s/manifests/apps/traefik-dashboard/ingress.yaml


echo 🟢 Installing Kubernetes Dashboard

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
# Create the account
kubectl apply -f k8s/manifests/apps/kubernetes-dashboard/account.yaml
# Create and get the idetification token
kubectl -n kubernetes-dashboard create token admin-user
# Apply ingress
kubectl apply -f k8s/manifests/apps/kubernetes-dashboard/ingress.yaml


echo 🟢 Installing Grafana
helm install grafana grafana/grafana \
--namespace monitoring --create-namespace \
--set adminPassword="admin" \
--set persistence.enabled=true \
--set persistence.size=10Gi \
--set persistence.storageClassName=local-path
kubectl apply -f k8s/manifests/apps/grafana/ingress.yaml

echo 🟢 Installing Loki
helm install loki grafana/loki \
-n monitoring \
-f k8s/manifests/apps/loki/values.yaml

echo 🟢 Installing Promtail
helm install promtail grafana/promtail -n monitoring

echo 🟢 Installing Prometheus
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
--namespace monitoring \
--set prometheus-node-exporter.enabled=true


echo 🟢 Installing Portainer
helm install portainer portainer/portainer \
--set service.type=ClusterIP \
--set service.port=9000 \
--set ingress.tls=""
kubectl apply -f k8s/manifests/apps/portainer/ingress.yaml


echo 🟢 Installing Elasticsearch
helm install elastic bitnami/elasticsearch \
--set security.enabled=false


echo 🟢 Installing Kibana
helm install kibana bitnami/kibana \
--set elasticsearch.host="elastic-elasticsearch" \
--set elasticsearch.port=9200 \
--set elasticsearch.hosts[0]="elastic-elasticsearch"
kubectl apply -f k8s/manifests/secrets/kibana.yaml
kubectl apply -f k8s/manifests/apps/kibana/middlewares/basic-auth.yaml
kubectl apply -f k8s/manifests/apps/kibana/ingress.yaml


echo 🟢 Installing MariaDB
kubectl apply -f k8s/manifests/apps/mariadb/pv.yaml \
&& kubectl apply -f k8s/manifests/secrets/mariadb.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/pvc.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/service.yaml \
&& kubectl apply -f k8s/manifests/apps/mariadb/deployment.yaml

echo 🟢 Installing Adminer
helm install adminer helm/charts/adminer --namespace default

echo 🟢 Installing Prometheus Mysql Exporter
helm upgrade --install mysql-exporter ./helm/charts/prometheus-mysql-exporter \
--namespace monitoring --create-namespace \
--set mysql.user="root" \
--set mysql.pass="secret-root-pass" \
--set mysql.host="mariadb.default.svc.cluster.local" \
--set mysql.port="3306"
kubectl apply -f k8s/manifests/apps/mysqld-exporter/service-monitor.yaml


echo ⌛ Waiting for MariaDB to be ready
sleep 90

echo 🟢 Provisionning database with test data
k3d image import faker-mysql-php --cluster dev-cluster \
&& kubectl apply -f k8s/manifests/secrets/mariadb.yaml \
&& kubectl apply -f k8s/manifests/jobs/faker-mysql-php.yaml \
&& sleep 10 \
&& kubectl logs -l job-name=populate-mariadb


echo 🟢 Installing PHP development environment
k3d image import k3d-php:latest -c dev-cluster \
&& kubectl apply -f k8s/manifests/configmaps/php-config.yaml \
&& kubectl apply -f k8s/manifests/apps/php/service.yaml \
&& kubectl apply -f k8s/manifests/apps/php/deployment.yaml \
&& kubectl apply -f k8s/manifests/apps/php/ingress.yaml

echo 🟢 Installing NodeJS development environment
k3d image import dev-js:latest --cluster dev-cluster \
&& helm upgrade --install dev-js helm/charts/dev-js

echo 🟢 Installing http-time test service
helm install http-time helm/charts/http-time --namespace default
