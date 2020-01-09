module "rabbitmq-config" {
  source = "..\/..\/..\/modules\/rabbitmq-config"
}

module "service-email-config" {
  source = "..\/..\/..\/modules\/services\/email-config"

  vhost_name = module.rabbitmq-config.vhost_name
}
