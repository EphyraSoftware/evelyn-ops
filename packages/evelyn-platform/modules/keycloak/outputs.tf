output "keycloak-admin-username" {
  value = "keycloak"
}

output "keycloak-admin-password" {
  value = random_password.admin-password.result
}
