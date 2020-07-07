module "traefik" {
  source = "../../module"

  namespace = "traefik"

  certificate_authority_root = data.terraform_remote_state.vault-ca.outputs.root-ca
  certificate_authority_int  = data.terraform_remote_state.vault-ca.outputs.int-ca
}
