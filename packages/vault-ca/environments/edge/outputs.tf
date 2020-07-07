output "root-ca" {
  value = module.vault-ca.root-ca
}

output "int-ca" {
  value = module.vault-ca.ca
}
