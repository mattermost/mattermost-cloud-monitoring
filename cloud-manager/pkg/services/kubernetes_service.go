package services

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/pkg/providers"
	k8sdrain "github.com/openshift/kubernetes-drain"
	"github.com/pkg/errors"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

const PodUnschedulable = "node.kubernetes.io/unschedulable"

type Service struct {
	contextName string
	client      *kubernetes.Clientset
	provider    providers.Provider
}

func NewKubernetesService(contextName string, provider providers.Provider) (*Service, error) {
	config, err := clientcmd.BuildConfigFromFlags("", defaultPath())
	if err != nil {
		return nil, fmt.Errorf("Failed to build k8s config: %s", err.Error())
	}

	client, err := kubernetes.NewForConfig(config)
	if err != nil {
		return nil, fmt.Errorf("Failed to create k8s client: %s", err.Error())
	}

	return &Service{contextName: contextName, client: client, provider: provider}, nil
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

func (s *Service) Drain(force, ignoreDaemonsets, deleteLocalData bool, namespace string, gracePeriodSeconds int, timeout time.Duration, forceTermination bool) error {
	nodeList, err := s.client.CoreV1().Nodes().List(metav1.ListOptions{})

	if err != nil {
		log.Printf("Failed to fetch k8s nodes due to %s", err.Error())
		return err
	}
	// get instances id map
	initialNodeSize := len(nodeList.Items)

	drainOptions := &k8sdrain.DrainOptions{
		Force:              force,
		IgnoreDaemonsets:   ignoreDaemonsets,
		GracePeriodSeconds: gracePeriodSeconds,
		Timeout:            timeout * time.Second,
		DeleteLocalData:    deleteLocalData,
		Namespace:          namespace,
		Logger:             s,
	}

	for _, item := range nodeList.Items {
		node := &item
		nodes := []*corev1.Node{node}

		log.Printf("Draining node %s", node.GetName())
		err = k8sdrain.Drain(s.client, nodes, drainOptions)
		if err != nil {
			log.Println(fmt.Sprintf("Failed to drain node %s due to %s", node.GetName(), err.Error()))
			return err
		}

		// teardown ec2 instance
		log.Println(fmt.Sprintf("Deleting node: %s", node.GetName()))
		isTerminated, err := s.provider.TerminateInstance(node.GetName(), forceTermination)
		if err != nil {
			err := errors.New(fmt.Sprintf("Failed to terminate node %s due to %s", node.GetName(), err.Error()))
			return err
		}
		if !isTerminated {
			return errors.New("Termination failed, please check if instance allows termination and/or specify the flag -force-termination")
		}

		isReady, err := s.verifyNew(initialNodeSize)
		if err != nil {
			return err
		}
		if !isReady {
			return errors.New("Node is not ready")
		}
	}
	return nil
}

// TODO: Does not handle race conditions from async creation of nodes when the script is running
func (s *Service) verifyNew(initialSize int) (bool, error) {
	nodeList, err := s.client.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		return false, err
	}

	readyNodes := s.filterReadyNodes(nodeList.Items)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
	defer cancel()

	for {
		select {
		case <-ctx.Done():
			err := errors.New("Timeout reached, while waiting for nodes to be ready")
			return false, err
		default:
			log.Println(fmt.Sprintf("Nodes ready: %x of %x", len(readyNodes), initialSize))
			if len(readyNodes) == initialSize {
				return true, nil
			}
			time.Sleep(15 * time.Second)
			nodeList, err := s.client.CoreV1().Nodes().List(metav1.ListOptions{})

			if err != nil {
				return false, err
			}
			readyNodes = s.filterReadyNodes(nodeList.Items)

		}
	}
}

func (s *Service) Log(v ...interface{}) {
	log.Println(v)
}

func (s *Service) Logf(format string, v ...interface{}) {
	log.Println(fmt.Sprintf(format, v))
}

// check if kubelet status is ready
func (s *Service) nodeIsReady(node corev1.Node) bool {
	for _, condition := range node.Status.Conditions {
		if condition.Type == "Ready" && condition.Reason == "KubeletReady" {
			return s.nodeIsSchedulable(node.Spec.Taints)
		}
	}
	return false
}

// check if node has any taints and if true if any taint is for unschedulable
func (s *Service) nodeIsSchedulable(taints []corev1.Taint) bool {
	if len(taints) == 0 {
		return true
	} else {
		for _, taint := range taints {
			if taint.Key != PodUnschedulable {
				return true
			}
		}
	}
	return false
}

func (s *Service) filterReadyNodes(nodes []corev1.Node) []corev1.Node {
	var readyNodes []corev1.Node
	for _, node := range nodes {
		if s.nodeIsReady(node) {
			readyNodes = append(readyNodes, node)
		}
	}
	return readyNodes
}
