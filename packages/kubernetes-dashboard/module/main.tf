resource "k8s-yaml_raw" "dashboard" {
  name     = "evelyn"
  file_url = "https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml"
}

resource "kubernetes_service_account" "admin-user" {
  depends_on = [k8s-yaml_raw.dashboard]

  metadata {
    name      = "kubernetes-dashboard-admin-user"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "admin-user" {
  depends_on = [k8s-yaml_raw.dashboard]

  metadata {
    name = "kubernetes-dashboard-admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin-user.metadata.0.name
    namespace = "kube-system"
  }
}
