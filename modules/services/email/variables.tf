variable "namespace" {
  description = "The k8s namespace."
  type = string

  default = "evelyn-services"
}

variable "image_pull_policy" {
  description = "The value for image pull policy."
  type = string

  default = "IfNotPresent"
}

variable "image" {
  description = "The container image to use."
  type = string
}

variable "image_pull_secret" {
  description = "The image pull secret to use."
  type = string

  default = "ghregcred"
}

variable rabbitmq_host {
  type = "string"

  default = "rabbitmq.evelyn-platform"
}

variable rabbitmq_port {
  type = "string"

  default = "5672"
}

variable mail_host {
  type = "string"

  default = "greenmail.evelyn-platform"
}

variable mail_port {
  type = "string"

  default = "3025"
}

variable mail_username {
  type = "string"

  default = "evelynmailer"
}

variable mail_password {
  type = "string"

  default = "passwd"
}

variable mail_smtp_host {
  type = "string"

  default = "greenmail.evelyn-platform"
}

variable spring_profiles_active {
  type = list(string)

  default = ["prod"]
}
