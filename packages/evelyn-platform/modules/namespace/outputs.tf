output "namespace" {
  value = kubernetes_namespace.evelyn-platform.metadata.0.name
}
