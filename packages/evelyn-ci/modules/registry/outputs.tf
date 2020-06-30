output "admin-username" {
  value = local.admin-username
}

output "admin-password" {
  value = random_password.admin_password.result
}

output "registry-hostname" {
  value = var.namespace
}
