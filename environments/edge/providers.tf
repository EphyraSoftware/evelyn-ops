provider "keystore" {
  path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles"
}

provider "rabbitmq" {
  endpoint = "http://127.0.0.1:6001"
  username = "guest"
  password = "guest"
}
