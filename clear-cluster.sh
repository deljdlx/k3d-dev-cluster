#!/bin/bash

echo "⚠️ ATTENTION : Ce script va supprimer TOUTES les ressources Kubernetes !"
read -p "Voulez-vous vraiment continuer ? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "❌ Annulation du reset."
    exit 1
fi

#!/bin/bash

echo "Suppression de toutes les ressources Kubernetes..."

# Suppression des ressources standards (namespaces, pods, services, etc.)
kubectl delete all --all --all-namespaces
kubectl delete pvc --all --all-namespaces
kubectl delete configmap --all --all-namespaces
kubectl delete secret --all --all-namespaces
kubectl delete ingress --all --all-namespaces
kubectl delete networkpolicy --all --all-namespaces

# Suppression des Custom Resource Definitions (CRDs)
kubectl delete crd --all

# Suppression des namespaces autres que ceux de base (kube-system, default, etc.)
for ns in $(kubectl get ns --no-headers -o custom-columns=":metadata.name"); do
  if [[ "$ns" != "default" && "$ns" != "kube-system" && "$ns" != "kube-public" && "$ns" != "kube-node-lease" ]]; then
    echo "Suppression du namespace : $ns"
    kubectl delete namespace $ns
  fi
done

# Suppression des Helm releases
echo "Suppression des releases Helm..."
for release in $(helm list --all --short); do
  echo "Désinstallation de $release..."
  helm uninstall $release
done

# Suppression des Helm repositories (facultatif)
echo "Suppression des repositories Helm..."
helm repo remove $(helm repo list --no-headers | awk '{print $1}')

echo "Nettoyage terminé !"
