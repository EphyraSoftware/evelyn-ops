provider "keystore" {
  path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles"
}

provider "rabbitmq" {
  endpoint = "https://${data.terraform_remote_state.evelyn-platform.outputs.rabbitmq_hostname}"
  username = data.terraform_remote_state.evelyn-platform.outputs.rabbitmq-management-user
  password = data.terraform_remote_state.evelyn-platform.outputs.rabbitmq-management-password
}

data "terraform_remote_state" "evelyn-platform" {
  backend = "local"

  config = {
    path = "\\\\nas.evelyn.internal\\terraform\\edge\\evelyn-platform.tfstate"
  }
}
