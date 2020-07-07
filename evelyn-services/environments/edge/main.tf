locals {
  image_pull_policy = "Always"
  image_registry = "registry.evelyn.internal"
}

//module "rabbitmq-config" {
//  source = "../../modules/rabbitmq-config"
//}

module "common" {
  source = "../../modules/common"

  registry_hostname = "${local.image_registry}:443"
  registry_email = "not-required@evelyn.internal"
}

//module "service-email-config" {
//  source = "../../modules/services/email-config"
//
//  vhost_name = module.rabbitmq-config.vhost_name
//}

module "keystore" {
  source = "../../modules/keystore"

  namespace = module.common.services_namespace_name
  trust_store_path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles\\truststore.p12"
}

//module "service-email" {
//  source = "../../modules/services/email"
//
//  namespace = module.common.services_namespace_name
//  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-email-service:dev"
//  image_pull_policy = local.image_pull_policy
//}
//
//module "service-profile" {
//  source = "../../modules/services/profile"
//
//  namespace = module.common.services_namespace_name
//  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-profile-service:dev"
//  image_pull_policy = local.image_pull_policy
//}
//
//module "service-group" {
//  source = "../../modules/services/group"
//
//  namespace = module.common.services_namespace_name
//  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-group-service:dev"
//  image_pull_policy = local.image_pull_policy
//}

module "service-task" {
  source = "../../modules/services/task"

  namespace = module.common.services_namespace_name
  image = "${local.image_registry}:443/ephyrasoftware/task-service:latest"
  image_pull_policy = local.image_pull_policy
  image_pull_secret = module.common.pull_secret
}

//module "service-calendar" {
//  source = "../../modules/services/calendar"
//
//  namespace = module.common.services_namespace_name
//  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-calendar-service:dev"
//  image_pull_policy = local.image_pull_policy
//}
//
//module "web-entry-point" {
//  source = "../../modules/services/web-entry-point"
//
//  namespace = module.common.services_namespace_name
//  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-web-entry-point:dev"
//  image_pull_policy = local.image_pull_policy
//}

module "ingress" {
  source = "../../modules/ingress"

  namespace = module.common.services_namespace_name
  external_shared_hostname = "service.evelyn.internal"
  tasks_service_name = module.service-task.service_name
  tasks_service_port = module.service-task.service_port
}
