package main

import (
	"fmt"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/providers"
	"os"
)

func main() {
	cloudProvider, err := providers.NewProvider("aws")
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	fmt.Println(cloudProvider.GetName())
}
