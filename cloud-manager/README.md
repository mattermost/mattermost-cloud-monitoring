# Cloud Manager CLI tool
Initially, this tool is built for rotating the kubernetes nodes to deploy a new AMI.

## Build
To make the binary run:
``make build``
## Usage
to run the tool:

`./bin/cloud-manager`

## Flags:

*  `-cloud-provider string`
    specifies the cloud provider for which to run a given command (default "aws")
*  `-rotate-amis`
    rotate amis command (default false)
##### Kubernetes Configuration Options
*   `-kube-context string`
    specifies which kube context to use (default "minikube") 
##### AWS Configuration Options
*   `-profile string`
    specifies which profile to use for AWS (default "default")
*  `-region string`
    specifies which region to use for AWS (default "eu-west-1")
    
##### Drain Options
* `-delete-local-data`
    Continue even if there are pods using emptyDir (local data that will be deleted when the node is drained) (default true)
*  `-force`
    Specifies drain to continue even if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet (default true)
* `-ignore-daemonsets`
    Ignore DaemonSet-managed pods (default true)
*   `-grace-period int`
    Time to wait gracefully for pods to evict (default 30 seconds)
*   `-namespace string`
    Which namespace to drain pods from. Leave empty for all namespaces.
*   `-timeout duration`
    Time to wait for drain of all pods in Seconds need to specified with the suffix `s` i.e. `90s` (default 1m30s)

*  `-help` 
    returns the above information
    
## Example usage
For EKS with usage of default values:

`./bin/cloud-manager -rotate-amis -kube-context=arn:aws:eks:eu-west-1:012345678901:cluster/clustername`

# Future improvements
* Argument to delete more than 1 node at a time
* Addition of credentials usage instead kubeconfig 
* Handle race conditions from async creation of nodes when the script is running
* Remove dependency on `github.com/openshift/kubernetes-drain`
* Usage of log
* Usage of different providers (Azure, GCP)
* Write tests for kubernetes service