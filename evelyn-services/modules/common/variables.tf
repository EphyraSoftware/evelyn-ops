variable services_namespace_name {
  type = string
  description = "The name of the services namespace"

  default = "evelyn-services"
}

variable "registry_hostname" {
  type = string
  description = "The hostname of the registry to get Evelyn images from"
}

variable "registry_email" {
  type = string
  description = "The email address to use for authentication to the registry"
}
