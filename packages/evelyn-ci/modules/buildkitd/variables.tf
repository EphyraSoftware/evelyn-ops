variable "namespace" {
  type        = string
  description = "The namespace to deploy to."
}

variable "image_tag" {
  type        = string
  description = "The image tag to use for moby/buildkit."
  default     = "master-rootless"
}

variable "port" {
  type        = number
  description = "The port to expose the buildkit daemon on."
  default     = 8999
}

variable "ingress_hostname" {
  type        = string
  description = "The ingress hostname to use"
}

variable "registry" {
  type    = string
  default = "docker.pkg.github.com"
}

variable "registry_email" {
  type = string
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type = string
}
