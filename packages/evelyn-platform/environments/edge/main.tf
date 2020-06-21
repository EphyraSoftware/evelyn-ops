module "namespace" {
  source = "../../modules/namespace"

  namespace = "evelyn-platform"
}

module "rabbitmq" {
  source = "../../modules/rabbitmq"

  namespace = module.namespace.namespace
}

module "mongodb" {
  source = "../../modules/mongodb"

  namespace = module.namespace.namespace
}

module "keycloak" {
  source = "../../modules/keycloak"

  namespace = module.namespace.namespace
}
