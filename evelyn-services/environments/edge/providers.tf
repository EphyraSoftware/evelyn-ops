provider "keystore" {
  path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles"
}

provider "rabbitmq" {
  endpoint = "http://edge.evelyn.internal:32233"
  username = "guest"
  password = "guest"
}
