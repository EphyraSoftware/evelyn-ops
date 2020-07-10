data "helm_repository" "rook" {
  name = "rook-release"
  url  = "https://charts.rook.io/release"
}

resource "kubernetes_namespace" "rook-ceph" {
  metadata {
    name = var.namespace
  }
}

resource "k8s-yaml_raw" "common" {
  name     = "common"
  file_url = "https://raw.githubusercontent.com/rook/rook/v1.3.1/cluster/examples/kubernetes/ceph/common.yaml"
}

resource "k8s-yaml_raw" "operator" {
  depends_on = [k8s-yaml_raw.common]

  name     = "operator"
  file_url = "https://raw.githubusercontent.com/rook/rook/v1.3.1/cluster/examples/kubernetes/ceph/operator.yaml"
}

resource "k8s-yaml_raw" "cluster" {
  depends_on = [k8s-yaml_raw.operator]

  name = "cluster"
  files = [
    "${path.module}/files/cluster-v1.3.1.yaml"
  ]
}

resource "k8s-yaml_raw" "block-storage" {
  depends_on = [k8s-yaml_raw.operator]

  name     = "block-storage"
  file_url = "https://raw.githubusercontent.com/rook/rook/v1.3.1/cluster/examples/kubernetes/ceph/csi/rbd/storageclass-test.yaml"
}

resource "k8s-yaml_raw" "file-system" {
  depends_on = [k8s-yaml_raw.operator]

  name     = "file-system"
  file_url = "https://raw.githubusercontent.com/rook/rook/v1.3.1/cluster/examples/kubernetes/ceph/filesystem-test.yaml"
}

resource "k8s-yaml_raw" "file-system-storage-class" {
  depends_on = [k8s-yaml_raw.file-system]

  name     = "file-system-storage-class"
  file_url = "https://raw.githubusercontent.com/rook/rook/v1.3.1/cluster/examples/kubernetes/ceph/csi/cephfs/storageclass.yaml"
}

resource "k8s-yaml_raw" "toolbox" {
  depends_on = [k8s-yaml_raw.operator]

  name     = "toolbox"
  file_url = "https://raw.githubusercontent.com/rook/rook/v1.3.1/cluster/examples/kubernetes/ceph/toolbox.yaml"
}
