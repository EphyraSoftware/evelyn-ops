output "email-user" {
  value = rabbitmq_user.email.name
}

output "email-password" {
  value = rabbitmq_user.email.password
}
