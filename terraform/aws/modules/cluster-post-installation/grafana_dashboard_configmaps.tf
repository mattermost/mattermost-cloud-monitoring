resource "kubernetes_config_map" "account_view" {
  metadata {
    name = "accountview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "account_view"
    }
  }

  data = {
    "account_view.json"="${file("../../../../../../grafana-dashboards/account_view.json")}"
  }
}

resource "kubernetes_config_map" "cluster_view" {
  metadata {
    name = "clusterview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "cluster_view"
    }
  }

  data = {
    "cluster_view.json"="${file("../../../../../../grafana-dashboards/cluster_view.json")}"
  }
}


resource "kubernetes_config_map" "installation_view" {
  metadata {
    name = "installationview-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "installation_view"
    }
  }

  data = {
    "installation_view.json"="${file("../../../../../../grafana-dashboards/installation_view.json")}"
  }
}


resource "kubernetes_config_map" "alerting" {
  metadata {
    name = "alerting-dashboard"
    namespace = "monitoring"
    labels = {
      cloud_dashboards = "alerting"
    }
  }

  data = {
    "alerting.json"="${file("../../../../../../grafana-dashboards/alerting.json")}"
  }
}

