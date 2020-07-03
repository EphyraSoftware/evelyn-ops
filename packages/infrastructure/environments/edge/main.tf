module "cillium" {
  source = "../../modules/cillium"
}

// Should not be enabled with NFS, only one is needed at a time.
/*module "rook" {
  source = "../../modules/rook"
}*/

module "nfs" {
  source = "../../modules/nfs"

  nfs-server-address = "192.168.1.32"
  nfs-exported-path = "/nfs"
}
