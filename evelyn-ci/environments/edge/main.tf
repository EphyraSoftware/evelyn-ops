module "buildkitd" {
  source = "../../modules/buildkitd"

  namespace = kubernetes_namespace.evelyn-ci.metadata.0.name
}
