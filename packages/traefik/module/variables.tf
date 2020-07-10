variable "namespace" {
  type        = string
  description = "The namespace to deploy to"
}

variable "certificate_authority_root" {
  type = string
}

variable "certificate_authority_int" {
  type = string
}
