output "client-cert-pem" {
  sensitive = true
  value = module.buildkit.client-cert-pem
}

output "client-cert-key" {
  sensitive = true
  value = module.buildkit.client-cert-key
}

output "ca-bundle" {
  value = module.buildkit.ca-bundle
}

//output "harbor-admin-password" {
//  value = module.harbor.harbor-admin-password
//}
