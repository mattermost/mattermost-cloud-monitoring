# Cloud Manager CLI tool
Initially, this tool is built for rotating the kubernetes nodes to deploy a new AMI.

## Build
To make the binary run:
``make build``
## Usage
to run the tool:

`./bin/cloud-manager`

#### Flags:

*  `-cloud-provider string`
    specifies the cloud provider for which to run a given command (default "aws")
*   `-kube-context string`
    specifies which kube context to use (default "minikube")
*   `-profile string`
    specifies which profile to use for AWS (default "default")
*  `-region string`
    specifies which region to use for AWS (default "eu-west-1")
*  `-rotate-amis`
    rotate amis command
*  `-help` 
    returns the above information
    
## Example usage
For EKS with usage of default values:

`./bin/cloud-manager -rotate-amis -kube-context=arn:aws:eks:eu-west-1:012345678901:cluster/clustername`

# ToDo
* Write tests

# Future improvements
* Check corner cases on not ready Nodes
* Argument to delete more than 1 node at a time
* Addition of credentials usage instead kubeconfig 
* Add arguments for DrainOptions
* Handle race conditions from async creation of nodes when the script is running
* Remove dependency on `github.com/openshift/kubernetes-drain`
* Usage of log
* Usage of different providers (Azure, GCP)