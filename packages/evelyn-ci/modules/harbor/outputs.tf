output "harbor-admin-password" {
  value = random_password.admin-password.result
}
