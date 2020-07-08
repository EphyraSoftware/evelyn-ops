output "rabbitmq-management-user" {
  value = local.rabbitmq_username
}

output "rabbitmq-management-password" {
  value = random_password.rabbitmq-password.result
}
