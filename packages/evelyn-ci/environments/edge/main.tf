module "namespace" {
  source = "../../modules/namespace"

  namespace = "evelyn-ci"
}

// Example command to test with
// buildctl --addr tcp://buildkit.evelyn.internal:443 --tlscacert ca-bundle.pem --tlscert crt.pem --tlskey key.pem --debug build --frontend=dockerfile.v0 --local context=. --local dockerfile=.
module "buildkit" {
  source = "../../modules/buildkitd"

  namespace = module.namespace.namespace
  ingress_hostname = "buildkit.evelyn.internal"

  registry_email = var.registry_email
  registry_username = var.registry_username
  registry_password = var.registry_password
}
