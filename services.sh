kubectl apply -f kubernetes/namespaces.yml
helm upgrade --install -n russet admission-webhook-server ../admission-webhook-server/helm
kubectl delete mutatingwebhookconfiguration admission-webhook-server -n russet
kubectl scale deploy admission-webhook-server -n russet --replicas=0
sleep 10
kubectl scale deploy admission-webhook-server -n russet --replicas=1
helm upgrade --install -n russet admission-webhook-server ../admission-webhook-server/helm
helm repo add jetstack https://charts.jetstack.io
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm upgrade --install traefik traefik/traefik --values kubernetes/treafik-values.yml --namespace russet
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.crds.yaml
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace russet \
  --create-namespace \
  --version v1.13.2 \
  --values kubernetes/cert-manager-values.yml
  # --set installCRDs=true