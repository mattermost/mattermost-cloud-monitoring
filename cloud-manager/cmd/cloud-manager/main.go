package main

import (
	"flag"
	"fmt"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/providers"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/services"
	"os"
)

func main() {
	rotateAmis := flag.Bool("rotate-amis", false, "rotate all kubernetes nodes")
	kubeContextName := flag.String("kube-context", "minikube", "specifies which kube context to use")
	cloudProviderName := flag.String("cloud-provider", "aws", "specifies the cloud provider for which to run a given command")
	ProfileName := flag.String("profile", "default", "specifies which profile to use for AWS")
	RegionName := flag.String("region", "eu-west-1", "specifies which region to use for AWS")
	force := flag.Bool("force", true, "Specifies drain to continue even if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet")
	ignoreDaemonsets := flag.Bool("ignore-daemonsets", true, "Ignore DaemonSet-managed pods")
	deleteLocalData := flag.Bool("delete-local-data", true, "Continue even if there are pods using emptyDir (local data that will be deleted when the node is drained)")
	flag.Parse()

	cloudProvider, err := providers.NewProvider(
		*cloudProviderName,
		*ProfileName,
		*RegionName,
	)
	LogErrorAndExit(err, "Failed to initialize provider")
	kubernetesService, err := services.NewKubernetesService(*kubeContextName, cloudProvider)
	LogErrorAndExit(err, "Failed to initialize k8s service")

	if *rotateAmis {
		err := kubernetesService.Drain(*force, *ignoreDaemonsets, *deleteLocalData)
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
		}
	}
}

func LogErrorAndExit(e error, msg string) {
	if e != nil {
		fmt.Println(e.Error())
		fmt.Println(msg)
		os.Exit(1)
	}
}
