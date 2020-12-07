resource "kubernetes_config_map" "account_monitoring" {
  metadata {
    name      = "accountmonitoring-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "account_monitoring"
    }
  }

  data = {
    "account_monitoring.json" = file("../../../../grafana-dashboards/account_monitoring.json")
  }
}

resource "kubernetes_config_map" "account_view" {
  metadata {
    name      = "accountview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "account_view"
    }
  }

  data = {
    "account_view.json" = file("../../../../grafana-dashboards/account_view.json")
  }
}

resource "kubernetes_config_map" "alerting" {
  metadata {
    name      = "alerting-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "alerting"
    }
  }

  data = {
    "alerting.json" = file("../../../../grafana-dashboards/alerting.json")
  }
}

resource "kubernetes_config_map" "aws_rds_overview" {
  metadata {
    name      = "awsrdsoverview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "aws_rds_overview"
    }
  }

  data = {
    "aws_rds_overview.json" = file("../../../../grafana-dashboards/aws_rds_overview.json")
  }
}

resource "kubernetes_config_map" "cluster_view" {
  metadata {
    name      = "clusterview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "cluster_view"
    }
  }

  data = {
    "cluster_view.json" = file("../../../../grafana-dashboards/cluster_view.json")
  }
}

resource "kubernetes_config_map" "coredns" {
  metadata {
    name      = "coredns-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "coredns"
    }
  }

  data = {
    "coredns.json" = file("../../../../grafana-dashboards/coredns.json")
  }
}

resource "kubernetes_config_map" "go_metrics_per_namespace_installation" {
  metadata {
    name      = "gometricspernamespaceinstallation-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "go_metrics_per_namespace_installation"
    }
  }

  data = {
    "go_metrics_per_namespace_installation.json" = file("../../../../grafana-dashboards/go_metrics_per_namespace_installation.json")
  }
}

resource "kubernetes_config_map" "installation_view" {
  metadata {
    name      = "installationview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "installation_view"
    }
  }

  data = {
    "installation_view.json" = file("../../../../grafana-dashboards/installation_view.json")
  }
}

resource "kubernetes_config_map" "mattermost_performance_kpi_metrics_per_cluster" {
  metadata {
    name      = "mattermostperformancekpimetricspercluster-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "mattermost_performance_kpi_metrics_per_cluster"
    }
  }

  data = {
    "mattermost_performance_kpi_metrics_per_cluster.json" = file("../../../../grafana-dashboards/mattermost_performance_kpi_metrics_per_cluster.json")
  }
}

resource "kubernetes_config_map" "mattermost_performance_monitoring_per_cluster" {
  metadata {
    name      = "mattermostperformancemonitoringpercluster-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "mattermost_performance_monitoring_per_cluster"
    }
  }

  data = {
    "mattermost_performance_monitoring_per_cluster.json" = file("../../../../grafana-dashboards/mattermost_performance_monitoring_per_cluster.json")
  }
}

resource "kubernetes_config_map" "skydns" {
  metadata {
    name      = "skydns-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "skydns"
    }
  }

  data = {
    "skydns.json" = file("../../../../grafana-dashboards/skydns.json")
  }
}

resource "kubernetes_config_map" "uptime_view" {
  metadata {
    name      = "uptimeview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "uptime_view"
    }
  }

  data = {
    "uptime_view.json" = file("../../../../grafana-dashboards/uptime_view.json")
  }
}
