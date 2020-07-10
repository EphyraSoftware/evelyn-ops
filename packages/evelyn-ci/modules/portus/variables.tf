variable "namespace" {
  type        = string
  description = "The namespace to deploy to"
}

variable "hostname" {
  type        = string
  description = "The name to use"
}

variable "storage_class_name" {
  type        = string
  description = "The storage class to use"
  default     = ""
}

variable "shared_storage_class_name" {
  type        = string
  description = "The multi-write storage class to use"
  default     = ""
}
