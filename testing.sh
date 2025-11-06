kubectl apply -f kubernetes/namespaces.yml
kubectl delete mutatingwebhookconfiguration admission-webhook-server -n russet
helm upgrade --install -n tools admission-webhook-server ../admission-webhook-server/helm
kubectl apply -f kubernetes/cluster-issuer.yml
kubectl apply -f kubernetes/wordpress1.yml
kubectl apply -f kubernetes/wordpress2.yml
kubectl apply -f kubernetes/wordpress3.yml
