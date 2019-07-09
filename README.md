Mattermost Cloud Command and Control Cluster
====================================================

This is a repo for the deployment of the Mattermost cloud command and control cluster. This cluster is used for the monitoring of the existing Cloud infrastructure as well as the provisioning of new Cloud infrastructure.

Several tools are used for the cluster monitoring/logging and the cluster deployment automation is done via Terraform and Helm.

## Mattermost Cloud Monitoring

The Mattermost Cloud Command and Control cluster is used to monitor the Mattermost cloud infrastructure. Prometheus and Grafana tooling is used to get and visualise metrics and the diagram below presents the solution architecture.

<span style="display:block;text-align:center">![monitoring](/img/monitoring.png)</span>

Prometheus Federation is used in order to get metrics from several Mattermost Cloud clusters and more info about the technology can be found [here](https://prometheus.io/docs/prometheus/latest/federation/). In order to make this work a central Prometheus server is needed, which can be seen in the diagram above. This central Prometheus server is used to scrape data from multiple other client Prometheus servers. In our case, from the Prometheus client server that sits in the Cloud Command and Control cluster to gather metrics from the cluster itself, as well as from the Prometheus client servers that are deployed in each of the Mattermost Cloud clusters.

The difficulty with the automation of this integration is that each new Prometheus client needs to be registered as target in the central Prometheus server. In order to achieve this, when a new Mattermost cluster is created by the Mattermost provisioner a Prometheus client is automatically deployed, as well as a Private NGINX ingress service and this is used to automatically register this Prometheus client with a private hosted zone Route53 record. Then the custom Prometheus DNS registration microservice is used to update the central Prometheus server with the new targets.

Grafana tool is used to visualise the metrics that are scraped by the central Prometheus app. Several dashboards are created to monitor the performance of the several clusters and Mattermost installations and in the future alerts will be added for instant actions based on the metrics.

### Prometheus DNS Registration Service

The Prometheus DNS registration service is a microservice running in AWS Lambda. As it was mentioned before, when a mew Mattermost cluster is created, a Prometheus client is deployed and registered with a Route53 private hosted zone record. Following the same logic, when a cluster is deleted this Prometheus client is deregistered from Route53. When a new Prometheus record gets registered/deregistered a Cloudwatch event is used to trigger the Prometheus DNS registration Lambda function.

At is can be seen in the diagram below, the lambda function authenticates with Amazon EKS and the command and control cluster and updates the Prometheus configmap with the new Prometheus client Route53 targets. 

The microservice is written in Golang and deployed via Terraform.

<span style="display:block;text-align:center">![monitoring](/img/prometheus_microservice.png)</span>

## Mattermost Cloud Logging

Three different tools are used for the Mattermost cloud logging. Fluentd is used to collect logs from all Mattermost cloud clusters, as well as the Mattermost cloud command and control cluster. Then these logs are sent to a Elasticsearch deployment which sits in the Mattermost command and control cluster as it can be seen in the diagram below. Finally, the Kibana app is used to visualise all logs sent to the central Elasticsearch application.

<span style="display:block;text-align:center">![monitoring](/img/logging.png)</span>

## Mattermost Provisioner

The Mattermost provisioner is a tool responsible for the provisioning of new Mattermost cloud clusters, as well as Mattermost installations. More information on the tool can be found [here](https://github.com/mattermost/mattermost-cloud). The Mattermost provisioner is deployed as part of the Mattermost cloud command and control cluster as it can be seen in the diagram below.

<span style="display:block;text-align:center">![monitoring](/img/provisioner.png)</span>

## Deployment Steps

For the deployment of the Mattermost central command and control cluster Terraform is used and it includes three different layers.

### 1. Cluster Layer

The cluster layer is responsible

### 2. Cluster Post Installation Layer

The cluster post installation layer is responsible

### 3. Route53 Registration Layer

The Route53 registration layer is responsible 

## Future Improvements

1. Private API Endpoint
2. 
