module "namespace" {
  source = "../../modules/namespace"
}

module "prometheus-operator" {
  source = "../../modules/prometheus-operator"

  namespace = module.namespace.namespace-name
  storage-class-name = "nfs-client"
}

module "elastic-search" {
  source = "../../modules/elastic-search"

  namespace = module.namespace.namespace-name
}

module "fluentd" {
  source = "../../modules/fluentd"
}

module "kibana" {
  source = "../../modules/kibana"

  namespace = module.namespace.namespace-name
}
