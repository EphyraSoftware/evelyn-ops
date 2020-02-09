module "buildkitd" {
  source = "../../modules/buildkitd"

  namespace = kubernetes_namespace.evelyn-ci.metadata.0.name
  expose_node_port = true
  server_dns_names = ["edge.evelyn.internal"]
}
