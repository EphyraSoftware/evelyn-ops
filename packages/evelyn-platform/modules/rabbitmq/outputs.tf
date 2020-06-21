output "rabbitmq-management-user" {
  value = data.kubernetes_secret.rabbitmq-ha.data["rabbitmq-management-username"]
}

output "rabbitmq-management-password" {
  value = data.kubernetes_secret.rabbitmq-ha.data["rabbitmq-management-password"]
}
