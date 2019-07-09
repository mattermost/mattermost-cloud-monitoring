Mattermost Cloud Command and Control Cluster
====================================================

This is a repo for the deployment of the Mattermost cloud command and control cluster. This cluster is used for the monitoring of the existing Cloud infrastructure as well as the provision of new Cloud infrastructure.

Several tools are used for the cluster monitoring/logging and the cluster deployment automation is done via Terraform and Helm.

## Mattermost Cloud Monitoring

The Mattermost Cloud Command and Control cluster is used to monitor the Mattermost cloud infrastructure. Prometheus and Grafana tooling is used to get and visualize metrics and the diagram below presents the solution architecture.

<span style="display:block;text-align:center">![monitoring](/img/monitoring.png)</span>

Prometheus Federation is used in order to get metrics from several Mattermost Cloud clusters. In order to make this work a central Prometheus is required that can be seen in the diagram above (far left in the design). This central Prometheus server is used to scrape data from multiple other client Prometheus servers. In our case, from the Prometheus client server that sits in the Cloud Command and Control cluster, as well as from the Prometheus client servers that are deployed in each of the Mattermost Cloud clusters. The technology used behind is called Prometheus Federation and more info can be found [here](https://prometheus.io/docs/prometheus/latest/federation/).

The difficulty with the automation of this integration is that each new Prometheus client needs to be registered as target in the central Prometheus server. In order to achieve this, when a new Mattermost cluster is created by the Mattermost provisioner a Prometheus client is automatically deployed, as well as an Private NGINX ingress service and this is used to automatically register this Prometheus client with a private hosted zone Route53 record. Then the custom Prometheus DNS registration microservice is used to update the central Promeheus server with the new targets.


### Prometheus DNS Registration Service


## Mattermost Cloud Logging


<span style="display:block;text-align:center">![monitoring](/img/logging.png)</span>


## Mattermost Provisioner

<span style="display:block;text-align:center">![monitoring](/img/provisioner.png)</span>


## Deployment Steps


## Future Improvements



