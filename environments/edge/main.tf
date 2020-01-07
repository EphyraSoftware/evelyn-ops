module "rabbitmq-config" {
  source = "../../modules/rabbitmq-config"
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

  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-email-service:dev"
}

module "service-profile" {
  source = "../../modules/services/profile"

  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-profile-service:dev"
}

module "service-group" {
  source = "../../modules/services/group"

  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-group-service:dev"
}

module "task-service" {
  source = "../../modules/services/task"

  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-task-service:dev"
}

module "calendar-service" {
  source = "../../modules/services/calendar"

  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-calendar-service:dev"
}

module "web-entry-point" {
  source = "../../modules/services/web-entry-point"

  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-web-entry-point:dev"
}
