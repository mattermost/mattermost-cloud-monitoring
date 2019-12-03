package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/services"
)

func main() {
	rotateAmis := flag.Bool("rotate-amis", false, "rotate amis command")
	kubeContextName := flag.String("kube-context", "minikube", "specifies which kube context to use")
	cloudProviderName := flag.String("cloud-provider", "aws", "specifies the cloud provider for which to run a given command")
	ProfileName := flag.String("profile", "default", "specifies which profile to use for AWS")
	RegionName := flag.String("region", "eu-west-1", "specifies which region to use for AWS")
	flag.Parse()

	kubernetesService, err := services.NewKubernetesService(*kubeContextName)

	LogErrorAndExit(err, "Failed to initialize k8s service")

	if *rotateAmis {
		kubernetesService.Drain(*cloudProviderName, *ProfileName, *RegionName)
	}

}

func LogErrorAndExit(e error, msg string) {
	if e != nil {
		fmt.Println(e.Error())
		fmt.Println(msg)
		os.Exit(1)
	}
}
