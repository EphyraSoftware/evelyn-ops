resource "random_password" "email-user" {
  length = 15
}

resource "rabbitmq_user" "email" {
  name     = "email"
  password = random_password.email-user.result
}

resource "rabbitmq_permissions" "email" {
  user = rabbitmq_user.email.name
  vhost = var.vhost_name

  permissions {
    configure = ".*"
    write = ".*"
    read = ".*"
  }
}

resource "rabbitmq_exchange" "email" {
  name = "user-messaging-exchange"
  vhost = rabbitmq_permissions.email.vhost

  settings {
    type = "topic"
    durable = true
    auto_delete = false
  }
}

resource "rabbitmq_queue" "email" {
  name = "send-mail"
  vhost = rabbitmq_permissions.email.vhost

  settings {
    durable = true
    auto_delete = false
  }
}

resource "rabbitmq_binding" "email" {
  source = rabbitmq_exchange.email.name
  vhost = var.vhost_name
  destination = rabbitmq_queue.email.name
  destination_type = "queue"
  routing_key = "none"
}
