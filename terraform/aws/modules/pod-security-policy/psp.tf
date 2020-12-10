locals {
  association-list = flatten([
    for namespace in keys(var.namespace-service-account-map) : [
      for service_account in var.namespace-service-account-map[namespace] : {
        namespace       = namespace
        service_account = service_account
      }
    ]
  ])
}

resource "kubernetes_pod_security_policy" "mm-privileged" {
  metadata {
    name = "mm-privileged"
    //    annotations {
    // kubernetes.io/description = "privileged allows full unrestricted access to pod features, as if the PodSecurityPolicy controller was not enabled."
    //    }
  }
  spec {
    privileged                 = true
    allow_privilege_escalation = true
    allowed_capabilities = [
      "*"
    ]

    volumes = [
      "*"
    ]

    run_as_user {
      rule = "RunAsAny"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    read_only_root_filesystem = true
  }
}
resource "kubernetes_pod_security_policy" "mm-non-privileged" {
  metadata {
    name = "mm-non-prvileged"
  }
  spec {
    privileged                 = false
    allow_privilege_escalation = false

    volumes = [
      "*"
    ]
    allowed_capabilities = [
      "*"
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    read_only_root_filesystem = true
  }
}

resource "kubernetes_secret" "non-privileged" {
  metadata {
    name      = "non-privileged"
    namespace = "default"
  }
  type = "Opaque"
}

resource "kubernetes_service_account" "non-privileged" {
  metadata {
    name      = "non-privileged"
    namespace = "default"
  }
  depends_on = [
    kubernetes_secret.non-privileged
  ]
}

resource "kubernetes_cluster_role" "non-privileged" {
  metadata {
    name = "non-privileged"
  }

  rule {
    api_groups     = ["extensions"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["mm-non-privileged"]
    verbs          = ["use"]
  }
  depends_on = [
    kubernetes_service_account.non-privileged
  ]
}

resource "kubernetes_cluster_role_binding" "non-privileged" {
  metadata {
    name = "non-privileged"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "non-privileged"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "non-privileged"
    namespace = "default"
  }
  subject {
    kind      = "Group"
    name      = "system:serviceaccounts" # all service accounts
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = "system:authenticated" # all authenticated users
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = "system:unauthenticated" # all unauthenticated users
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [
    kubernetes_cluster_role.non-privileged,
    kubernetes_service_account.non-privileged
  ]
}

resource "kubernetes_cluster_role" "privileged" {
  metadata {
    name = "privileged"
  }
  rule {
    api_groups     = ["extensions"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["mm-privileged"]
    verbs          = ["use"]
  }
}


resource "kubernetes_role_binding" "privileged-role-bindings" {

  metadata {
    name      = "privileged"
    namespace = local.association-list[count.index].namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "privileged"
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.association-list[count.index].service_account
    namespace = local.association-list[count.index].namespace
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kube-proxy"
    namespace = "kube-system"
  }
  depends_on = [kubernetes_cluster_role.privileged]

}

resource "kubernetes_secret" "privileged-secrets" {

  for_each = var.namespaces

  metadata {
    name      = "privileged"
    namespace = each.value
  }

  type = "Opaque"
}

resource "kubernetes_service_account" "privileged-service-accounts" {
  for_each = var.namespaces

  metadata {
    name      = "privileged"
    namespace = each.value
  }
  depends_on = [kubernetes_secret.privileged-secrets]
}
