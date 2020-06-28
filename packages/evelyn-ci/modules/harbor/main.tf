resource "vault_pki_secret_backend_cert" "harbor" {
  backend = "pki_intermediate"
  name = "evelyn-internal-role"

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = var.harbor-hostname
}

resource "vault_pki_secret_backend_cert" "notary" {
  backend = "pki_intermediate"
  name = "evelyn-internal-role"

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = var.notary-hostname
}

resource "kubernetes_secret" "harbor-tls" {
  metadata {
    name = "harbor-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.harbor.certificate
    "tls.key" = vault_pki_secret_backend_cert.harbor.private_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "notary-tls" {
  metadata {
    name = "notary-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.notary.certificate
    "tls.key" = vault_pki_secret_backend_cert.notary.private_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "ca-bundle" {
  metadata {
    name = "harbor-ca-bundle"
    namespace = var.namespace
  }
  data = {
    "ca.crt" = vault_pki_secret_backend_cert.harbor.ca_chain
  }
}

resource "helm_release" "harbor" {
  chart = "harbor"
  name = "harbor"
  namespace = var.namespace
  repository = "https://helm.goharbor.io"
  version = "1.4.0"

  set {
    name = "expose.tls.secretName"
    value = kubernetes_secret.harbor-tls.metadata.0.name
  }

  set {
    name = "expose.tls.notarySecretName"
    value = kubernetes_secret.notary-tls.metadata.0.name
  }

  set {
    name = "expose.ingress.hosts.core"
    value = var.harbor-hostname
  }

  set {
    name = "expose.ingress.hosts.notary"
    value = var.notary-hostname
  }

  set {
    name = "externalURL"
    value = "http://${var.harbor-hostname}"
  }

  set {
    name = "secretKey"
    value = random_password.secret-key.result
  }

  set {
    name = "harborAdminPassword"
    value = random_password.admin-password.result
  }

  set {
    name = "caBundleSecretName"
    value = kubernetes_secret.ca-bundle.metadata.0.name
  }
}

resource "random_password" "secret-key" {
  length = 16
  special = false
}

resource "random_password" "admin-password" {
  length = 12
  special = false
}
