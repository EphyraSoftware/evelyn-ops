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

variable web_entry_point_keystore_secret_name {
  description = "The name of the secret which contains the web entry point keystore."
  type = "string"

  default = "web-entry-point-keystore"
}

variable spring_profiles_active {
  description = "The Spring profiles which should be active."
  type = list(string)

  default = ["prod"]
}

variable profile_service_host {
  type = "string"
  default = "evelyn-profile-service.evelyn-services.svc.cluster.local:8080"
}

variable group_service_host {
  type = "string"
  default = "evelyn-group-service.evelyn-services:8080"
}

variable task_service_host {
  type = "string"
  default = "evelyn-task-service.evelyn-services.svc.cluster.local:8080"
}

variable calendar_service_host {
  type = "string"
  default = "evelyn-calendar-service.evelyn-services.svc.cluster.local:8080"
}
