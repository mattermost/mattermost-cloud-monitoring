This module can be used to deploy the Gitlab application in a k8s cluster.

The first time gitlab is created the install_gitlab_runner variable needs to be set to false. The reason is gitlab runner needs to be able to register with the Gitlab domain. But the domain is created after the deployment of Gitlab. Therefore the module needs to be rerun after the initial deployment with install_gitlab_runner set to true this time.
