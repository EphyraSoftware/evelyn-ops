data "keystore_pkcs12_bundle" "profile-service" {
  name = "profile-service-keystore"
}

resource "local_file" "profile-service-tmp" {
  filename = "${path.module}/tmp/profile-service-keystore.p12"
  content_base64 = data.keystore_pkcs12_bundle.profile-service.bundle
}
