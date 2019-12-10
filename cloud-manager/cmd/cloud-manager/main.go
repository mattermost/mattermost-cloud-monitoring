package main

import (
	"flag"
	"fmt"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/providers"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/services"
	"os"
	"time"
)

func main() {
	rotateAmis := flag.Bool("rotate-amis", false, "Rotate all kubernetes nodes")
	kubeContextName := flag.String("kube-context", "minikube", "Specifies which kube context to use")
	cloudProviderName := flag.String("cloud-provider", "aws", "Specifies the cloud provider for which to run a given command")
	ProfileName := flag.String("profile", "default", "Specifies which profile to use for AWS")
	RegionName := flag.String("region", "eu-west-1", "Specifies which region to use for AWS")
	force := flag.Bool("force", true, "Specifies drain to continue even if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet")
	forceTermination := flag.Bool("force-termination", false, "Specifies termination of instances when termination protection is enabled")
	ignoreDaemonsets := flag.Bool("ignore-daemonsets", true, "Ignore DaemonSet-managed pods")
	deleteLocalData := flag.Bool("delete-local-data", true, "Continue even if there are pods using emptyDir (local data that will be deleted when the node is drained)")
	namespace := flag.String("namespace", "", "Which namespace to drain pods from. Leave empty for all namespaces.")
	gracePeriodSeconds := flag.Int("grace-period", 30, "Time to wait gracefully for pods to evict")
	timeout := flag.Duration("timeout", 90*time.Second, "Time to wait for drain of all pods in Seconds")
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
		err := kubernetesService.Drain(*force, *ignoreDaemonsets, *deleteLocalData, *namespace, *gracePeriodSeconds, *timeout, *forceTermination)
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
