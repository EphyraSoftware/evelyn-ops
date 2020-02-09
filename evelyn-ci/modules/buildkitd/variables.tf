variable "namespace" {
  type = string
  description = "The namespace to deploy to."
  default = "evelyn-ci"
}

variable "image_tag" {
  type = string
  description = "The image tag to use for moby/buildkit."
  default = "master-rootless"
}

variable "port" {
  type = number
  description = "The port to expose the buildkit daemon on."
  default = 8999
}

variable "expose_node_port" {
  type = bool
  description = "Whether to expose a NodePort service for buildkitd."
  default = false
}

variable "node_port" {
  type = number
  description = "The node port to expose."
  default = 31015
}

variable "server_dns_names" {
  type = list(string)
  description = "List of DNS names to use for the server certificate"
  default = []
}
