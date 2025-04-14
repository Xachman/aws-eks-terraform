resource "kubernetes_namespace" "amber" {
  metadata {
    name = "amber"
  }
}

resource "kubernetes_namespace" "russet" {
  metadata {
    name = "russet"
  }
}
