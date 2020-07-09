locals {
  namespace         = "evelyn-services"
  image_pull_policy = "Always"
  image_registry    = "registry.evelyn.internal"

  mongodb_connection_uri = "mongodb://mongodb-replicaset.evelyn-platform:27017/"
  rabbitmq_host          = "rabbitmq.evelyn-platform"
}

module "rabbitmq-config" {
  source = "../../modules/rabbitmq-config"
}

module "common" {
  source = "../../modules/common"

  registry_hostname = "${local.image_registry}:443"
  registry_email    = "not-required@evelyn.internal"
}

module "service-email-config" {
  source = "../../modules/services/email-config"

  vhost_name = module.rabbitmq-config.vhost_name
}

module "keystore" {
  source = "../../modules/keystore"

  namespace        = module.common.services_namespace_name
  trust_store_path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles\\truststore.p12"
}

module "service-email" {
  source = "../../modules/services/email"

  namespace         = module.common.services_namespace_name
  image             = "${local.image_registry}:443/ephyrasoftware/email-service:latest"
  image_pull_policy = local.image_pull_policy
  image_pull_secret = module.common.pull_secret
  rabbitmq_host     = local.rabbitmq_host
  rabbitmq_username = module.service-email-config.email-user
  rabbitmq_password = module.service-email-config.email-password
}

module "service-profile" {
  source = "../../modules/services/profile"

  namespace            = module.common.services_namespace_name
  image                = "${local.image_registry}:443/ephyrasoftware/profile-service:latest"
  image_pull_policy    = local.image_pull_policy
  image_pull_secret    = module.common.pull_secret
  mongo_connection_uri = local.mongodb_connection_uri
  rabbitmq_host        = local.rabbitmq_host
}

module "service-group" {
  source = "../../modules/services/group"

  namespace                = module.common.services_namespace_name
  image                    = "${local.image_registry}:443/ephyrasoftware/group-service:latest"
  image_pull_policy        = local.image_pull_policy
  image_pull_secret        = module.common.pull_secret
  mongo_connection_uri     = local.mongodb_connection_uri
  profile_service_base_url = "https://${module.service-profile.service_name}.${local.namespace}.svc.cluster.local:8080"
}

module "service-task" {
  source = "../../modules/services/task"

  namespace                = module.common.services_namespace_name
  image                    = "${local.image_registry}:443/ephyrasoftware/task-service:latest"
  image_pull_policy        = local.image_pull_policy
  image_pull_secret        = module.common.pull_secret
  mongo_connection_uri     = local.mongodb_connection_uri
  profile_service_base_url = "https://${module.service-profile.service_name}.${local.namespace}.svc.cluster.local:8080"
}

module "service-todo" {
  source = "../../modules/services/todo"

  namespace                = module.common.services_namespace_name
  image                    = "${local.image_registry}:443/ephyrasoftware/todo-service:latest"
  image_pull_policy        = local.image_pull_policy
  image_pull_secret        = module.common.pull_secret
  mongo_connection_uri     = local.mongodb_connection_uri
  profile_service_base_url = "https://${module.service-profile.service_name}.${local.namespace}.svc.cluster.local:8080"
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

  namespace                = module.common.services_namespace_name
  external_shared_hostname = "service.evelyn.internal"
  task_service_name        = module.service-task.service_name
  task_service_port        = module.service-task.service_port
  profile_service_name     = module.service-profile.service_name
  profile_service_port     = module.service-profile.service_port
  group_service_name       = module.service-group.service_name
  group_service_port       = module.service-group.service_port
  todo_service_name        = module.service-todo.service_name
  todo_service_port        = module.service-todo.service_port
}
