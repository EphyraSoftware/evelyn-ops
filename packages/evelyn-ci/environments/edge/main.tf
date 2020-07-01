module "namespace" {
  source = "../../modules/namespace"

  namespace = "evelyn-ci"
}

module "registry" {
  source = "../../modules/registry"

  namespace = module.namespace.namespace
  hostname = "registry.evelyn.internal"
}

// Example command to test with
// buildctl --addr tcp://buildkit.evelyn.internal:443 --tlscacert ca-bundle.pem --tlscert crt.pem --tlskey key.pem --debug build --frontend=dockerfile.v0 --local context=. --local dockerfile=.
module "buildkit" {
  source = "../../modules/buildkitd"

  namespace = module.namespace.namespace
  ingress_hostname = "buildkit.evelyn.internal"

  registry = module.registry.registry-hostname
  registry_email = "${module.registry.admin-username}@evelyn.internal"
  registry_username = module.registry.admin-username
  registry_password = module.registry.admin-password
}

//module "portus" {
//  source = "../../modules/portus"
//
//  namespace = module.namespace.namespace
//
//  hostname = "portus.evelyn.internal"
//}

//module "harbor" {
//  source = "../../modules/harbor"
//
//  namespace = module.namespace.namespace
//  harbor-hostname = "harbor.evelyn.internal"
//  notary-hostname = "notary.evelyn.internal"
//}
