output "rabbitmq_hostname" {
  value = local.rabbitmq_hostname
}

output "rabbitmq-management-user" {
  value = module.rabbitmq.rabbitmq-management-user
}

output "rabbitmq-management-password" {
  value = module.rabbitmq.rabbitmq-management-password
}

output "keycloak-admin-username" {
  value = module.keycloak.keycloak-admin-username
}

output "keycloak-admin-password" {
  value = module.keycloak.keycloak-admin-password
}
