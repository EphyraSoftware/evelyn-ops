variable "namespace" {
  type        = string
  description = "The namespace to deploy to"
}

variable "rabbitmq_hostname" {
  type        = string
  description = "The hostname for rabbitmq ingress"
}
