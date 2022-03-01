Mattermost Cloud Command and Control Cluster
====================================================

This is a repo for the deployment of the Mattermost Cloud command and control cluster. This cluster is used for the monitoring of the existing Cloud infrastructure as well as the provisioning of new Cloud infrastructure.

Several tools are used for the cluster monitoring/logging and the cluster deployment automation is done via Terraform and Helm.

## Mattermost Cloud Monitoring

The Mattermost Cloud Command and Control cluster is used to monitor the Mattermost Cloud infrastructure. Prometheus, Thanos and Grafana tooling is used to get and visualise metrics and the diagram below presents the solution architecture.

<span style="display:block;text-align:center">![monitoring](/img/monitoring.png)</span>

### Prometheus Operator

The Prometheus Operator is deployed in the Command and Control cluster and all provisioning clusters. It is deployed using the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) Helm chart and it is used to scrape cluster and Mattermost application metrics. Together with the Prometheus operator, the Thanos sidecar is deployed and it pushes metrics to the respective account metrics storage bucket every two hours. The Prometheus Alert Manager is also deployed in the Command and Control cluster to handle all metric alerts. More information on the Prometheus operator can be found [here](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

### Thanos 

The thanos tool is added on top of the Prometheus deployment and it offers a highly available metric system, utilizing S3 object storage. More information on Thanos can be found [here](https://github.com/thanos-io/thanos). A number of Thanos components are deployed as part of the Thanos Helm [chart](https://bitnami.com/stack/thanos/helm) and more specifically:

#### Thanos Querier:
- Deployed in each provisioning cluster to query metrics from each Prometheus operator sidecar.
- Deployed in the Command and Control cluster to query the Command and Control cluster Prometheus operator sidecar, all the provisioning clusters Thanos queries and the metrics storage bucket
  
#### Thanos Compactor: 
- Applies compaction procedure to block data stored in S3
- Responsible for downsampling of data - performing 5m downsampling of data after 40 hours and 1h downsampling after 10 days.

#### Thanos Gateway:
- Occupies small amounts of disk space for caching basic information about data in the S3 object storage.

#### Thanos Ruler
- Does the same thing as the querier but for Prometheus rules. It can communicate with Thanos components and use the Prometheus Alert manager to send metric alerts. 

### Grafana 

Grafana tool is used to visualise the metrics from the central Thanos querier. Several dashboards are created to monitor the performance of the Mattermost clusters and installations. These dashboards are focusing on getting the Account view, the Clusters view, the Installations view, as well as Database metrics and Account quotas utilization.

### Thanos Store Discovery

Mattermot Thanos store discovery tool is a microservice designed to work in a multi-cluster environment, with the purpose to automatically register new Thanos query endpoints in a central Thanos deployment. More information on this Mattermost tool can be found [here](https://github.com/mattermost/cloud-thanos-store-discovery)

This tool is deployed via Terraform and runs as a cronjob every 5 minutes. The following k8s components are deployed together with the cronjob:

- Service Account
- Role
- Role Binding

The components above are used to give to give the tool the required permissions to get/create/update configmaps, get/list deployments and get/list/delete pods in the monitoring namespace. 

## Mattermost Cloud Logging

Three different tools are used for the Mattermost Cloud logging. Fluentbit is used to collect logs from all Mattermost Cloud clusters, as well as the Mattermost Cloud command and control cluster. Then these logs are sent to a central Elasticsearch deployment in the Mattermost command and control vpc as it can be seen in the diagram below. Finally, the Kibana app is used to visualise all logs sent to the central Elasticsearch application. The AWS managed Elasticsearch and Kibana service is used.

<span style="display:block;text-align:center">![monitoring](/img/logging.png)</span>

## Mattermost Provisioner

The Mattermost provisioner is a tool responsible for the provisioning of new Mattermost Cloud clusters, as well as Mattermost installations. More information on the tool can be found [here](https://github.com/mattermost/mattermost-cloud). The Mattermost provisioner server is deployed in the Mattermost Cloud command and control cluster as it can be seen in the diagram below.

<span style="display:block;text-align:center">![monitoring](/img/provisioner.png)</span>

## Deployment Steps

For the deployment of the Mattermost central command and control cluster Terraform is used and it includes three different layers.

### 1. Cluster Layer

The cluster layer is responsible for the deployment of the cluster infrastructure, including the cluster master and nodes, IAM, networking and cluster authentication. With the successful deployment of this layer, an empty cluster is provisioned that will be shaped by running the next layers. In addition, in this first layer the prometheus DNS registration service is deployed as the Lambda role needs to be added to the cluster auth configmap for trust purposes.

### 2. Cluster Post Installation Layer

The cluster post installation layer is responsible for the installation of all the applications that are required by the Mattermost command and control cluster. This includes the deployment of Prometheus, Grafana, Kibana, Fluentd, Elasticsearch and the Mattermost Provisioner applications, as well as ingress configuration, certificate management, app authentication and k8s cluster dashboard. Both the Helm and the Kubernetes Terraform providers are used for the deployment of this layer.

### 3. Route53 Registration Layer

The Route53 registration layer is the last layer to get deployed. This layer is responsible for the DNS registration of all the applications that were deployed in the second layer and need to be either privately or publicly accessible.

### New Environment Deployment

In order to deploy the Mattermost command and control cluster in a new environment, a new environment should be created under [environments](https://github.com/mattermost/mattermost-cloud-monitoring/tree/master/terraform/aws), and **main.tf**, **output.tf** and **variables.tf** can be copied from an existing environment. The **variables.tf** and the *bucket* name in the **main.tf**, should be updated to reflect the new environment resources. Once the new environment values are added, the Makefile **ENVIRONMENT** variable should be updated with the environment name. In addition, IAM Secret and Access keys should be created and exported locally. By running the following command all the layers of the Mattermost command and control cluster will be deployed in the specified environment.

```bash
make all
```

In the case that specific layers need to be deployed the rest of the Makefile options or individual Terraform commands can be used.
