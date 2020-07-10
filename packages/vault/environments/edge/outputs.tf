output "ca" {
  value = module.vault.ca
}

resource "local_file" "ca" {
  filename = "ca.pem"
  content  = module.vault.ca
}
