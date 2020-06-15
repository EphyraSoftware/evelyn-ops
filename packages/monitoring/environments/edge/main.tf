module "namespace" {
  source = "../../modules/namespace"
}

module "prometheus-operator" {
  source = "../../modules/prometheus-operator"

  namespace = module.namespace.namespace-name
  storage-class-name = "nfs-client"
}
