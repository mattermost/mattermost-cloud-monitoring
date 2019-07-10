Mattermost Cloud Command and Control Cluster
====================================================

This is a repo for the deployment of the Mattermost cloud command and control cluster. This cluster is used for the monitoring of the existing Cloud infrastructure as well as the provisioning of new Cloud infrastructure.

Several tools are used for the cluster monitoring/logging and the cluster deployment automation is done via Terraform and Helm.

## Mattermost Cloud Monitoring

The Mattermost Cloud Command and Control cluster is used to monitor the Mattermost cloud infrastructure. Prometheus and Grafana tooling is used to get and visualise metrics and the diagram below presents the solution architecture.

<span style="display:block;text-align:center">![monitoring](/img/monitoring.png)</span>

Prometheus Federation is used to scrape metrics from several Mattermost Cloud clusters and more info about the technology can be found [here](https://prometheus.io/docs/prometheus/latest/federation/). For this setup, a central Prometheus server is needed, which can be seen in the diagram above. This central Prometheus server is used to scrape data from multiple other client Prometheus servers. In our case, from the Prometheus client server that is deployed in the Cloud command and control cluster to gather metrics from the cluster itself, as well as from the Prometheus client servers that are deployed in each of the Mattermost Cloud clusters.

The difficulty with the automation of this integration is that each new Prometheus client needs to be registered as target in the central Prometheus server. In order to achieve this, when a new Mattermost cluster is created by the Mattermost provisioner a Prometheus client is automatically deployed, as well as a Private NGINX ingress service that is used to automatically register this Prometheus client with a private hosted zone Route53 record. Then the custom Prometheus DNS registration microservice is used to update the central Prometheus server with the new targets.

Grafana tool is used to visualise the metrics that are scraped by the central Prometheus app. Several dashboards are created to monitor the performance of the several clusters and Mattermost installations and in the future alerts will be added to take actions based on the metrics.

### Prometheus DNS Registration Service

The Prometheus DNS registration service is a microservice running in AWS Lambda. As it was mentioned before, when a mew Mattermost cluster is created, a Prometheus client is deployed and registered with a Route53 private hosted zone record. Following the same logic, when a cluster is deleted this Prometheus client is deregistered from Route53. When a new Prometheus record gets registered/deregistered a Cloudwatch event is used to trigger the Prometheus DNS registration Lambda function.

At is can be seen in the diagram below, the lambda function authenticates with Amazon EKS and the command and control cluster and updates the Prometheus configmap with the new Prometheus client Route53 targets.

The microservice is written in Golang and deployed via Terraform.

<span style="display:block;text-align:center">![monitoring](/img/prometheus_microservice.png)</span>

## Mattermost Cloud Logging

Three different tools are used for the Mattermost cloud logging. Fluentd is used to collect logs from all Mattermost cloud clusters, as well as the Mattermost cloud command and control cluster. Then these logs are sent to a Elasticsearch deployment which is deployed in the Mattermost command and control cluster as it can be seen in the diagram below. Finally, the Kibana app is used to visualise all logs sent to the central Elasticsearch application.

<span style="display:block;text-align:center">![monitoring](/img/logging.png)</span>

## Mattermost Provisioner

The Mattermost provisioner is a tool responsible for the provisioning of new Mattermost cloud clusters, as well as Mattermost installations. More information on the tool can be found [here](https://github.com/mattermost/mattermost-cloud). The Mattermost provisioner server is deployed in the Mattermost cloud command and control cluster as it can be seen in the diagram below.

<span style="display:block;text-align:center">![monitoring](/img/provisioner.png)</span>

## Deployment Steps

For the deployment of the Mattermost central command and control cluster Terraform is used and it includes three different layers.

### 1. Cluster Layer

The cluster layer is responsible for the deployment of the cluster infrastructure, including the cluster master and nodes, IAM, networking and cluster authentication. With the successful deployment of this layer, an empty cluster is provisioned that will be shaped by running the next layers. In addition, in this first layer the prometheus DNS registration service is deployed as the Lambda role needs to be added to the cluster auth configmap for trust purposes.

### 2. Cluster Post Installation Layer

The cluster post installation layer is responsible for the intallation of all the applications that are required by the Mattermost command and control cluster. This includes the deployment of Prometheus, Grafana, Kibana, Fluentd, Elasticsearch and the Mattermost Provisioner applications, as well as ingress configuration, certificate management, app authentication and k8s cluster dashboard. Both the Helm and the Kubernetes Terraform providers are used for the deployment of this layer.

### 3. Route53 Registration Layer

The Route53 registration layer is the last layer to get deployed. This layer is responsible for the DNS registration of all the applications that were deployed in the second layer and need to be either privately or publicly accesible.

### New Environment Deployment

In order to deploy the Mattermost command and control cluster in a new environment, a new environment should be created under [environments](https://github.com/mattermost/mattermost-cloud-monitoring/tree/master/terraform/aws), and **main.tf**, **output.tf** and **variables.tf** can be copied from an existing environment. The **variables.tf** and the *bucket* name in the **main.tf**, should be updated to reflect the new environment resources. Once the new environment values are added, the Makefile **ENVIRONMENT** variable should be updated with the environment name. In addition, IAM Secret and Access keys should be created and exported locally. By running the following command all the layers of the Mattermost command and control cluster will be deployed in the specified environment.

```bash
make all
```

In the case that specific layers need to be deployed the rest of the Makefile options or individual Terraform commands can be used.

## Future Improvements

### 1. Private API Endpoint

The current Mattermost command and control cluster configuration is using both a private and a public endpoints. The private endpoint is used for all cluster communications except the k8s api which is using the public endpoint. The reason for that is that when EKS private endpoint is selected for all communications a private hosted zone (cannot be used) that sits in the VPC of the cluster is created. Therefore, access to this endpoint can be achieved only from within the VPC. There is a [solution](https://aws.amazon.com/blogs/compute/enabling-dns-resolution-for-amazon-eks-cluster-endpoints/) at the moment that enables DNS resolution for other accounts but requires lots of manual steps, so a different approach should be examined prior to production release.

Possible solutions:

- VPN in each of the accounts
- Proxies in each of the accounts that allow traffic from central VPN
- AWS to allow access to the private hosted zone

### 2. Use IAM role with Terraform 

IAM keys are required at the moment for the deployment of the Terraform layers. This should be changed to make use of IAM roles instead.

### 3. Make all application DNS records private

At the moment applications such as Grafana, Prometheus and Kibana can be accessed via a public record and there is an authentication level on top. As a future security improvement, they should be moved to make use of private records that will be accessible only via the VPN service.

### 4. Grafana dashboards

Basic dashboards have been created at the moment to monitor the performance of the Mattermost Cloud servers and installations. The use of more complex dashboards and the introduction of alerts should be examined in the future.
