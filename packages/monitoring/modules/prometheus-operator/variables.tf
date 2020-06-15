variable "namespace" {
  type = string
  description = "The namespace to deploy to"
}

variable "storage-class-name" {
  type = string
  description = "The storage class name to use for persistent storage"
}
