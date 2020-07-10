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
}

variable group_service_keystore_config_map_name {
  description = "The name of the config map which contains the group service keystore."
  type = string

  default = "group-service-keystore"
}

variable spring_profiles_active {
  description = "The Spring profiles which should be active."
  type = list(string)

  default = ["prod"]
}

variable mongo_connection_uri {
  description = "The MongoDB connection URI."
  type = string
}

variable keycloak_auth_url {
  description = "The Keycloak authentication URL."
  type = string

  default = "https://keycloak.evelyn.internal/auth"
}

variable profile_service_base_url {
  description = "The base URL of the profile service (with no trailing slash)."
  type = string
}
