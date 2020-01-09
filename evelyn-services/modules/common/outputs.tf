output "services_namespace_name" {
  value = kubernetes_namespace.services-namespace.metadata[0].name
}
