resource "k8s-yaml_raw" "fluentd" {
  name = "fluentd"
  files = [
    "${path.module}/files/daemonset.yaml"
  ]
}
