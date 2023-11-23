helm repo add jetstack https://charts.jetstack.io
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik --values kubernetes/treafik-values.yml 
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.crds.yaml
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.13.2 \
  --values kubernetes/cert-manager-values.yml
  # --set installCRDs=true