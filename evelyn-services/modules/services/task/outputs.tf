output "service_name" {
  value = kubernetes_service.task-service.metadata.0.name
}

output "service_port" {
  value = kubernetes_service.task-service.spec[0].port[0].name
}
