data "keystore_pkcs12_bundle" "calendar-service" {
  name = "calendar-service-keystore"
}

resource "kubernetes_config_map" "calendar-service-keystore" {
  metadata {
    name = "calendar-service-keystore"
    namespace = var.namespace
  }

  binary_data = {
    "calendar-service-keystore.p12" = data.keystore_pkcs12_bundle.calendar-service.bundle
    "truststore.p12" = filebase64(var.trust_store_path)
  }
}

data "keystore_pkcs12_bundle" "group-service" {
  name = "group-service-keystore"
}

resource "kubernetes_config_map" "group-service-keystore" {
  metadata {
    name = "group-service-keystore"
    namespace = var.namespace
  }

  binary_data = {
    "group-service-keystore.p12" = data.keystore_pkcs12_bundle.group-service.bundle
    "truststore.p12" = filebase64(var.trust_store_path)
  }
}

data "keystore_pkcs12_bundle" "profile-service" {
  name = "profile-service-keystore"
}

resource "kubernetes_config_map" "profile-service-keystore" {
  metadata {
    name = "profile-service-keystore"
    namespace = var.namespace
  }

  binary_data = {
    "profile-service-keystore.p12" = data.keystore_pkcs12_bundle.profile-service.bundle
    "truststore.p12" = filebase64(var.trust_store_path)
  }
}

data "keystore_pkcs12_bundle" "task-service" {
  name = "task-service-keystore"
}

resource "kubernetes_config_map" "task-service-keystore" {
  metadata {
    name = "task-service-keystore"
    namespace = var.namespace
  }

  binary_data = {
    "task-service-keystore.p12" = data.keystore_pkcs12_bundle.task-service.bundle
    "truststore.p12" = filebase64(var.trust_store_path)
  }
}

data "keystore_pkcs12_bundle" "web-entry-point" {
  name = "web-entry-point-keystore"
}

resource "kubernetes_config_map" "web-entry-point-keystore" {
  metadata {
    name = "web-entry-point-keystore"
    namespace = var.namespace
  }

  binary_data = {
    "web-entry-point-keystore.p12" = data.keystore_pkcs12_bundle.web-entry-point.bundle
    "truststore.p12" = filebase64(var.trust_store_path)
  }
}
