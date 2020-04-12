resource "k8s-yaml_raw" "cillium" {
  name = "evelyn"
  file_url = "https://raw.githubusercontent.com/cilium/cilium/v1.7.2/install/kubernetes/quick-install.yaml"
}
