variable "nfs-server-address" {
  type = string
  description = "The IP address or hostname of the NFS server"
}

variable "nfs-exported-path" {
  type = string
  description = "The directory path which is exported from the NFS server for use by Kubernetes"
}
