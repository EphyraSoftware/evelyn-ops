variable "trust_store_path" {
  description = "The file path to the truststore to use."
  type        = string
}

variable "namespace" {
  description = "The k8s namespace."
  type        = string
}
