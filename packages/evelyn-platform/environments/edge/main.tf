locals {
  rabbitmq_hostname = "rabbitmq.evelyn.internal"
}

module "namespace" {
  source = "../../modules/namespace"

  namespace = "evelyn-platform"
}

// Doesn't cope with cluster restarts: https://github.com/helm/charts/issues/13485
//module "rabbitmq-ha" {
//  source = "../../modules/rabbitmq-ha"
//
//  namespace = module.namespace.namespace
//  rabbitmq_hostname = local.rabbitmq_hostname
//}

module "rabbitmq" {
  source = "../../modules/rabbitmq"

  namespace = module.namespace.namespace
  rabbitmq_hostname = local.rabbitmq_hostname
}

module "mongodb" {
  source = "../../modules/mongodb"

  namespace = module.namespace.namespace
}

module "keycloak" {
  source = "../../modules/keycloak"

  namespace = module.namespace.namespace
  keycloak_hostname = "keycloak.evelyn.internal"
}

module "mailhog" {
  source = "../../modules/mailhog"

  namespace = module.namespace.namespace
  hostname = "mailhog.evelyn.internal"
}
