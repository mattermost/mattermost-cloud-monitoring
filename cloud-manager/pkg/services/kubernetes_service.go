package services

import (
	"fmt"
	k8sdrain "github.com/openshift/kubernetes-drain"
	"github.com/pkg/errors"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"os"
	"path/filepath"
	"time"
)

type Service struct {
	contextName string
	client      *kubernetes.Clientset
}

func NewKubernetesService(contextName string) (*Service, error) {
	config, err := clientcmd.BuildConfigFromFlags("", defaultPath())
	if err != nil {
		return nil, errors.New(fmt.Sprintf("Failed to build k8s config: %s", err.Error()))
	}

	client, err := kubernetes.NewForConfig(config)
	if err != nil {
		return nil, errors.New(fmt.Sprintf("Failed to create k8s client: %s", err.Error()))
	}

	return &Service{contextName: contextName, client: client}, nil
}

func defaultPath() string {
	return filepath.Join(homeDir(), ".kube", "config")
}

func homeDir() string {
	if h := os.Getenv("HOME"); h != "" {
		return h
	}
	return os.Getenv("USERPROFILE") // windows
}

func (s *Service) Drain() error {
	nodeList, err := s.client.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		fmt.Println(fmt.Sprintf("Failed to fetch k8s nodes due to %s", err.Error()))
		return err
	}

	for _, item := range nodeList.Items {
		node := &item
		nodes := []*corev1.Node{node}

		drainOptions := &k8sdrain.DrainOptions{
			Force:              true,
			IgnoreDaemonsets:   true,
			GracePeriodSeconds: 120,
			Timeout:            10 * time.Second,
			DeleteLocalData:    false,
			Namespace:          "default",
			Logger:             s,
		}

		fmt.Println(fmt.Sprintf("Going to start draining node %s", node.GetName()))
		err = k8sdrain.Drain(s.client, nodes, drainOptions)
		if err != nil {
			fmt.Println(fmt.Sprintf("Failed to drain node %s due to %s", node.GetName(), err.Error()))
			return err
		}
		fmt.Println(fmt.Sprintf("Finish draining node %s", node.GetName()))

		// teardown ec2 instance
		// wait for node to be up
	}
	return nil
}

func (s *Service) waitUntilTearDown() {

}

func (s *Service) verifyNew() {

}

func (s *Service) Log(v ...interface{}) {
	fmt.Println(v)
}

func (s *Service) Logf(format string, v ...interface{}) {
	fmt.Println(fmt.Sprintf(format, v))
}
