resource "helm_release" "nfs-client-provisioner" {
  chart   = "stable/nfs-client-provisioner"
  name    = "nfs-client-provisioner"
  version = "1.2.8"

  set {
    name  = "nfs.server"
    value = var.nfs-server-address
  }

  set {
    name  = "nfs.path"
    value = var.nfs-exported-path
  }
}
