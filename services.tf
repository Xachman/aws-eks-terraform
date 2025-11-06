resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  namespace  = "traefik"
  create_namespace = true
  version = "v37.1.1"
  # old version = "v32.1.1" 
  # new version = "v37.1.1" 

  values = [<<EOF
---
nodeSelector:
  env: russet

service:
  enabled: true
  type: LoadBalancer
  annotations:
    # Specify the load balancer scheme as internet-facing to create a public-facing Network Load Balancer (NLB)
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
  # Additional annotations applied to both TCP and UDP services (e.g. for cloud provider specific config)
  # Additional annotations for TCP service only
  annotationsTCP: {}
  # Additional annotations for UDP service only
  annotationsUDP: {}
  # Additional service labels (e.g. for filtering Service by custom labels)
  spec:
    externalTrafficPolicy: Cluster
    # loadBalancerIP: "1.2.3.4"
    # clusterIP: "2.3.4.5"
  loadBalancerSourceRanges: []
    # - 192.168.0.1/32
    # - 172.16.0.0/16
  externalIPs: []
    # - 1.2.3.4
  # One of SingleStack, PreferDualStack, or RequireDualStack.
  # ipFamilyPolicy: SingleStack
logs:
  general:
    # -- By default, the logs use a text format (common), but you can
    # also ask for the json format in the format option
    # format: json
    # By default, the level is set to ERROR.
    # -- Alternative logging levels are DEBUG, PANIC, FATAL, ERROR, WARN, and INFO.
    level: INFO 
EOF
  ]
  depends_on = [module.eks]
}


resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  values = [<<EOF
nodeSelector:
  env: russet
EOF
  ]
  depends_on = [module.eks]
}

# resource "kubernetes_manifest" "staging_issuer" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name      = "staging-issuer"
#     }
#     spec = {
#       acme = {
#         server = "https://acme-staging-v02.api.letsencrypt.org/directory"
#         privateKeySecretRef = {
#           name = "staging-issuer-account-key"
#         }
#         solvers = [{
#           http01 = {
#             ingress = {
#               ingressClassName = "traefik"
#             }
#           }
#         }]
#       }
#     }
#   }
#   depends_on = [ helm_release.cert_manager ]
# }
