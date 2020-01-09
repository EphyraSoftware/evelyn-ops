resource "kubernetes_namespace" "services-namespace" {
  metadata {
    name = var.services_namespace_name

    labels = {
      name = var.services_namespace_name
    }
  }
}
