output "ca-cert" {
  value = module.buildkitd.ca-cert
}

output "client-cert-pem" {
  value = module.buildkitd.client-cert-pem
}

output "client-cert-key" {
  value = module.buildkitd.client-cert-key
}
