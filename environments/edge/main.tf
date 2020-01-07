module "rabbitmq-config" {
  source = "../../modules/rabbitmq-config"
}

module "common" {
  source = "../../modules/common"
}

module "service-email-config" {
  source = "../../modules/services/email-config"

  vhost_name = module.rabbitmq-config.vhost_name
}

module "keystore" {
  source = "../../modules/keystore"
}

module "service-email" {
  source = "../../modules/services/email"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-email-service:dev"
}

module "service-profile" {
  source = "../../modules/services/profile"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-profile-service:dev"
}

module "service-group" {
  source = "../../modules/services/group"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-group-service:dev"
}

module "service-task" {
  source = "../../modules/services/task"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-task-service:dev"
}

module "service-calendar" {
  source = "../../modules/services/calendar"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-calendar-service:dev"
}

module "web-entry-point" {
  source = "../../modules/services/web-entry-point"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-web-entry-point:dev"
}
