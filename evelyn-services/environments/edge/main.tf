locals {
  image_pull_policy = "Always"
}

module "rabbitmq-config" {
  source = "..\/..\/..\/modules\/rabbitmq-config"
}

module "common" {
  source = "..\/..\/..\/modules\/common"
}

module "service-email-config" {
  source = "..\/..\/..\/modules\/services\/email-config"

  vhost_name = module.rabbitmq-config.vhost_name
}

module "keystore" {
  source = "..\/..\/..\/modules\/keystore"

  namespace = module.common.services_namespace_name
  trust_store_path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles\\truststore.p12"
}

module "service-email" {
  source = "..\/..\/..\/modules\/services\/email"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-email-service:dev"
  image_pull_policy = local.image_pull_policy
}

module "service-profile" {
  source = "..\/..\/..\/modules\/services\/profile"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-profile-service:dev"
  image_pull_policy = local.image_pull_policy
}

module "service-group" {
  source = "..\/..\/..\/modules\/services\/group"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-group-service:dev"
  image_pull_policy = local.image_pull_policy
}

module "service-task" {
  source = "..\/..\/..\/modules\/services\/task"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-task-service:dev"
  image_pull_policy = local.image_pull_policy
}

module "service-calendar" {
  source = "..\/..\/..\/modules\/services\/calendar"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-calendar-service:dev"
  image_pull_policy = local.image_pull_policy
}

module "web-entry-point" {
  source = "..\/..\/..\/modules\/services\/web-entry-point"

  namespace = module.common.services_namespace_name
  image = "docker.pkg.github.com/ephyrasoftware/evelyn-service/evelyn-web-entry-point:dev"
  image_pull_policy = local.image_pull_policy
}
