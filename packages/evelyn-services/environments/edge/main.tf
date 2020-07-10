locals {
  namespace         = "evelyn-services"
  image_pull_policy = "Always"
  image_registry    = "registry.evelyn.internal"

  mongodb_connection_uri = "mongodb://mongodb-replicaset.evelyn-platform:27017/"
  rabbitmq_host          = "rabbitmq.evelyn-platform"
  mail_host              = "mailhog.evelyn-platform"
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
  # For some reason this authentication doesn't work, so root credentials it is... sadly
  rabbitmq_username = data.terraform_remote_state.evelyn-platform.outputs.rabbitmq-management-user     # module.service-email-config.email-user
  rabbitmq_password = data.terraform_remote_state.evelyn-platform.outputs.rabbitmq-management-password # module.service-email-config.email-password
  mail_host         = local.mail_host
  mail_smtp_host    = local.mail_host
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

module "service-calendar" {
  source = "../../modules/services/calendar"

  namespace            = module.common.services_namespace_name
  image                = "${local.image_registry}:443/ephyrasoftware/calendar-service:latest"
  image_pull_policy    = local.image_pull_policy
  image_pull_secret    = module.common.pull_secret
  mongo_connection_uri = local.mongodb_connection_uri
  rabbitmq_host        = local.rabbitmq_host
  # For some reason this authentication doesn't work, so root credentials it is... sadly
  rabbitmq_username        = data.terraform_remote_state.evelyn-platform.outputs.rabbitmq-management-user     # module.service-email-config.email-user
  rabbitmq_password        = data.terraform_remote_state.evelyn-platform.outputs.rabbitmq-management-password # module.service-email-config.email-password
  profile_service_base_url = "https://${module.service-profile.service_name}.${local.namespace}.svc.cluster.local:8080"
}

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
