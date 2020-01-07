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

variable task_service_keystore_secret_name {
  description = "The name of the secret which contains the task service keystore."
  type = "string"

  default = "task-service-keystore"
}

variable spring_profiles_active {
  description = "The Spring frameworks which should be active."
  type = list(string)

  default = ["prod"]
}

variable mongo_connection_uri {
  description = "The MongoDB connection URI."
  type = "string"

  default = "mongodb://mongodb.evelyn-platform:27017/"
}

variable keycloak_auth_url {
  description = "The Keycloak authentication URL."
  type = "string"

  default = "https://keycloak.evelyn.internal:31739/auth"
}
