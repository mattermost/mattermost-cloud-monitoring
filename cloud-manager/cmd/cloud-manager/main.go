package main

import (
	"flag"
	"fmt"
	"os"
	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/providers"
)

func LogErrorAndExit(e error) {
	if e != nil {
		fmt.Println(e.Error())
		os.Exit(1)
	}
}

// func exitErrorf(msg string, args ...interface{}) {
// 	fmt.Fprintf(os.Stderr, msg+"\n", args...)
// 	os.Exit(1)
// }
func main() {
	rotateAmis := flag.Bool("rotate-amis", false, "rotate amis command")
	cloudProviderName := flag.String("cloud-provider", "aws", "specifies the cloud provider for which to run a given command")
	ProfileName := flag.String("profile", "default", "specifies which profile to use for AWS")
	RegionName := flag.String("region", "eu-west-1", "specifies which region to use for AWS")
	flag.Parse()

	cloudProvider, err := providers.NewProvider(
		*cloudProviderName,
		*ProfileName,
		*RegionName,
	)
	LogErrorAndExit(err)

	if *rotateAmis {
		fmt.Println(fmt.Sprintf("Going to rotate amis for provider %s", cloudProvider.GetName()))
	}
}
