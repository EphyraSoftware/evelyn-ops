module "namespace" {
  source = "../../modules/namespace"

  namespace = "evelyn-platform"
}

module "rabbitmq" {
  source = "../../modules/rabbitmq"

  namespace = module.namespace.namespace
}
