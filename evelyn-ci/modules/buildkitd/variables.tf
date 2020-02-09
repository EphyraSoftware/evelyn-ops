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
