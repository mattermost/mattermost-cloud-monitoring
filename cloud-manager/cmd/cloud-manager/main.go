package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/services"
)

func main() {
	rotateAmis := flag.Bool("rotate-amis", false, "rotate amis command")
	kubeContextName := flag.String("kube-context", "arn:aws:eks:eu-west-1:609445407176:cluster/tf-pre-prod-01", "specifies which kube context to use")
	flag.Parse()

	kubernetesService, err := services.NewKubernetesService(*kubeContextName)

	if err != nil {
		fmt.Println("Failed to initialize k8s service")
		os.Exit(1)
	}

	if *rotateAmis {
		kubernetesService.Drain()
	}
}
