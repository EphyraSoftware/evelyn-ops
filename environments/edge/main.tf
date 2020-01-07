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
