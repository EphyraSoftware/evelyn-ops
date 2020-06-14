output "admin-secret-name" {
  value = kubernetes_service_account.admin-user.default_secret_name
}
