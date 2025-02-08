
# Kubectl Cheatsheet - Catégories de Commandes

## SORT ME

```bash
kubectl rollout restart deployment traefik-router -n default


kubectl run -n monitoring debug-pod --rm -it --image=curlimages/curl -- sh

kubectl run mysql-client --rm -it --image=mysql:latest -- bash
kubectl run mysql-client --rm -it --image=mysql:5.7 --restart=Never -- bash
kubectl run -it --rm debug --image=alpine -- sh
apk add curl


kubectl port-forward svc/mysql-exporter-prometheus-mysql-exporter 9104 -n monitoring
kubectl port-forward -n monitoring service/mysql-exporter-prometheus-mysql-exporter 9104:9104
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090



helm pull prometheus-community/prometheus-mysql-exporter --untar




```


## Info

```bash
kubectl cluster-info
kubectl get deployments
kubectl get middleware -n default


# connecect to traefic pod
kubectl exec -it -n kube-system $(kubectl get pods -n kube-system -l app.kubernetes.io/name=traefik -o jsonpath="{.items[0].metadata.name}") -- sh
```

# Tools
```bash
# copy conf
kubectl get deployment -n kube-system traefik -o yaml > traefik-deployment.yaml
```w

## Lister les ressources
- Lister les pods
```bash
kubectl get pods
```
- Lister les services
```bash
kubectl get services
```
- Lister les namespaces
```bash
kubectl get namespaces
```
- Lister les deployments
```bash
kubectl get deployments
```
- Lister les ingress
```bash
kubectl get ingress
```
- Lister les jobs
```bash
kubectl get jobs
```
- Lister les secrets
```bash
kubectl get secrets
```
- Lister les configmaps
```bash
kubectl get configmaps
```
- Lister les persistent volumes (PV)
```bash
kubectl get pv
```
- Lister les persistent volume claims (PVC)
```bash
kubectl get pvc
```

## Créer une ressource
- Créer un pod
```bash
kubectl apply -f pod.yaml
```
- Créer un service
```bash
kubectl apply -f service.yaml
```
- Créer un deployment
```bash
kubectl apply -f deployment.yaml
```
- Créer un ingress
```bash
kubectl apply -f ingress.yaml
```
- Créer un job
```bash
kubectl apply -f job.yaml
```
- Créer un secret
```bash
kubectl apply -f secret.yaml
```
- Créer un configmap
```bash
kubectl apply -f configmap.yaml
```
- Créer un persistent volume (PV)
```bash
kubectl apply -f pv.yaml
```
- Créer un persistent volume claim (PVC)
```bash
kubectl apply -f pvc.yaml
```

## Obtenir des détails sur une ressource
- Détails d'un pod
```bash
kubectl describe pod <pod-name>
```
- Détails d'un service
```bash
kubectl describe service <service-name>
```
- Détails d'un deployment
```bash
kubectl describe deployment <deployment-name>
```
- Détails d'un ingress
```bash
kubectl describe ingress <ingress-name>
```
- Détails d'un job
```bash
kubectl describe job <job-name>
```

## Mettre à jour ou modifier des ressources
- Modifier une ressource avec un éditeur
```bash
kubectl edit <resource-type> <resource-name>
```
- Appliquer un patch à une ressource
```bash
kubectl patch <resource-type> <resource-name> -p '{"spec": {"replicas": 3}}'
```
- Mettre à jour l'image d'un container dans un deployment
```bash
kubectl set image deployment/<deployment-name> <container-name>=<new-image>
```
- Modifier le nombre de réplicas d'un deployment
```bash
kubectl scale deployment <deployment-name> --replicas=<number>
```

## Supprimer des ressources
- Supprimer un pod
```bash
kubectl delete pod <pod-name>
```
- Supprimer un service
```bash
kubectl delete service <service-name>
```
- Supprimer un deployment
```bash
kubectl delete deployment <deployment-name>
```
- Supprimer un ingress
```bash
kubectl delete ingress <ingress-name>
```
- Supprimer un job
```bash
kubectl delete job <job-name>
```
- Supprimer un namespace
```bash
kubectl delete namespace <namespace-name>
```
- Supprimer un secret
```bash
kubectl delete secret <secret-name>
```
- Supprimer un configmap
```bash
kubectl delete configmap <configmap-name>
```
- Supprimer un persistent volume (PV)
```bash
kubectl delete pv <pv-name>
```
- Supprimer un persistent volume claim (PVC)
```bash
kubectl delete pvc <pvc-name>
```

## Interagir avec les pods
- Exécuter une commande dans un pod
```bash
kubectl exec -it <pod-name> -- <command>
```
- Obtenir les logs d'un pod
```bash
kubectl logs <pod-name>
```
- Suivre les logs d'un pod en temps réel
```bash
kubectl logs -f <pod-name>
```

## Monitoring et diagnostic
- Afficher les ressources utilisées par les pods
```bash
kubectl top pods
```
- Afficher les ressources utilisées par les nodes
```bash
kubectl top nodes
```
- Afficher les événements du cluster
```bash
kubectl get events
```
- Afficher les ressources allouées (CPU, mémoire) pour un pod
```bash
kubectl describe pod <pod-name> | grep -i "cpu"
```

## Gérer les namespaces
- Créer un namespace
```bash
kubectl create namespace <namespace-name>
```
- Changer de namespace
```bash
kubectl config set-context --current --namespace=<namespace-name>
```
- Supprimer un namespace
```bash
kubectl delete namespace <namespace-name>
```

## Autres commandes utiles
- Gérer les contextes Kubernetes
```bash
kubectl config get-contexts
```
- Exporter une ressource au format YAML
```bash
kubectl get <resource-type> <resource-name> -o yaml
```
- Sauvegarder toutes les ressources du cluster
```bash
kubectl get all --all-namespaces -o yaml > all-resources.yaml
```
