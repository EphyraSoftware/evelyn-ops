variable "services_namespace" {
  type = string
  default = "evelyn-services"
}

variable "hostname" {
  type = string
  description = "The hostname of the Vault instance"
}
