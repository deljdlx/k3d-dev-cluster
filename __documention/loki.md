

helm install loki grafana/loki \
--namespace monitoring --create-namespace \
--set persistence.enabled=true \
--set persistence.size=10Gi \
--set persistence.storageClassName=local-path \
--set loki.commonConfig.replication_factor=1


helm install loki grafana/loki \
--namespace monitoring \
--set persistence.enabled=true \
--set persistence.size=10Gi \
--set persistence.storageClassName=local-path \
--set loki.commonConfig.replication_factor=1 \
--set loki.storageConfig.boltdb_shipper.activeIndexDirectory=/data/loki/index \
--set loki.storageConfig.boltdb_shipper.sharedStore=filesystem \
--set loki.storage.bucketNames.chunks=loki-chunks \
--set loki.storage.bucketNames.index=loki-index \
--set loki.storage.bucketNames.ruler=loki-ruler

