// ex:
// routing key: none
// durable: true
// queue: send-mail

resource "rabbitmq_vhost" "evelyn_vhost" {
  name = "evelyn_vhost"
}

