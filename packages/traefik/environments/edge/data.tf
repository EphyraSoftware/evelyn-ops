data "terraform_remote_state" "vault-ca" {
  backend = "local"

  config = {
    path = "\\\\nas.evelyn.internal\\terraform\\edge\\vault-ca.tfstate"
  }
}
