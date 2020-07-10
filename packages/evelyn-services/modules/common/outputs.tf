output "services_namespace_name" {
  value = kubernetes_namespace.services-namespace.metadata[0].name
}

output "pull_secret" {
  value = kubernetes_secret.evelyn-registry.metadata.0.name
}
