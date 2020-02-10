module "buildkitd" {
  source = "../../modules/buildkitd"

  namespace = kubernetes_namespace.evelyn-ci.metadata.0.name
  expose_node_port = true
  server_dns_names = [
    "edge.evelyn.internal"
  ]

  registry_username = var.registry_username
  registry_email = var.registry_email
  registry_password = var.registry_password
}

module "artifactory" {
  source = "../../modules/artifactory"
}
