module "vault-ca" {
  source = "../../module"
}

resource "local_file" "ca-out" {
  filename = "ca.crt"
  content = module.vault-ca.root-ca
}

resource "local_file" "ca-int-out" {
  filename = "ca-int.crt"
  content = module.vault-ca.ca
}

resource "local_file" "ca-bundle" {
  filename = "ca-bundle.pem"
  content = "${module.vault-ca.root-ca}\n${module.vault-ca.ca}"
}
