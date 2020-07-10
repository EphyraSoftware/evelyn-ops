variable "namespace" {
  type        = string
  description = "The namespace to deploy to"
}

variable "storage_class_name" {
  type        = string
  description = "The storage class name to use for persistent storage"
}

variable "grafana_hostname" {
  type        = string
  description = "The hostname to use for Grafana"
}
