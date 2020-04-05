package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/kubernetes-sigs/aws-iam-authenticator/pkg/token"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/eks"
	"github.com/aws/aws-sdk-go/service/route53"
	"github.com/aws/aws-sdk-go/service/sts"
	"github.com/aws/aws-sdk-go/service/sts/stsiface"
	"github.com/pkg/errors"

	log "github.com/sirupsen/logrus"
	yaml "gopkg.in/yaml.v2"
	clientset "k8s.io/client-go/kubernetes"
)

// This structure is used to decode the configmap
type config struct {
	Global struct {
		EvaluationInterval string `yaml:"evaluation_interval"`
		ScrapeInterval     string `yaml:"scrape_interval"`
		ScrapeTimeOut      string `yaml:"scrape_timeout"`
	} `yaml:"global"`
	RuleFiles []string `yaml:"rule_files"`
	Alerting  struct {
		Alertmanagers []struct {
			Scheme        string `yaml:"scheme,omitempty"`
			StaticConfigs []struct {
				Targets []string `yaml:"targets"`
			} `yaml:"static_configs"`
		} `yaml:"alertmanagers"`
	} `yaml:"alerting"`
	ScrapeConfigs []struct {
		HonorLabels bool   `yaml:"honor_labels"`
		JobName     string `yaml:"job_name"`
		MetricsPath string `yaml:"metrics_path"`
		Perams      struct {
			Match []string `yaml:"match[]"`
			Module [] string `yaml:"module"`
		} `yaml:"params"`
		ScrapeInterval string `yaml:"scrape_interval"`
		StaticConfigs  []struct {
			Targets []string `yaml:"targets"`
			Labels  struct {
				ClusterID string `yaml:"clusterID"`
			} `yaml:"labels"`
		} `yaml:"static_configs"`
		RelabelConfigs []struct {
			SourceLabels []string `yaml:"source_labels,omitempty"`
			TargetLabel string `yaml:"target_label,omitempty"`
			Replacement string `yaml:"replacement,omitempty"`
		} `yaml:"relabel_configs"`
	} `yaml:"scrape_configs"`
}

type clusterConfig struct {
	ClusterName              string
	MasterEndpoint           string
	CertificateAuthorityData string
	Session                  *session.Session
}

type clientConfig struct {
	Client      *clientcmdapi.Config
	ClusterName string
	ContextName string
	roleARN     string
	sts         stsiface.STSAPI
}

type staticConfig = struct {
	Targets []string `yaml:"targets"`
	Labels  struct {
		ClusterID string `yaml:"clusterID"`
	} `yaml:"labels"`
}

type relabelConfig = struct {
	SourceLabels []string `yaml:"source_labels,omitempty"`
	TargetLabel string `yaml:"target_label,omitempty"`
	Replacement string `yaml:"replacement,omitempty"`
}

var excludedURLs = []string{
	"dev.cloud.mattermost.com.",
	"test.cloud.mattermost.com.",
	"staging.cloud.mattermost.com.",
	"prod.cloud.mattermost.com.",
	"core.cloud.mattermost.com.",
	"vpn.cloud.mattermost.com.",
}

func main() {
	lambda.Start(handler)
}

func handler() {
	prometheusHostedZoneID := os.Getenv("PROMETHEUS_HOSTED_ZONE_ID")
	if len(prometheusHostedZoneID) == 0 {
		log.Fatal("PROMETHEUS_HOSTED_ZONE_ID environment variable is not set.")
		return
	}
	installationsHostedZoneID := os.Getenv("INSTALLATIONS_HOSTED_ZONE_ID")
	if len(installationsHostedZoneID) == 0 {
		log.Fatal("INSTALLATIONS_HOSTED_ZONE_ID environment variable is not set.")
		return
	}
	environment := os.Getenv("ENVIRONMENT")
	if len(environment) == 0 {
		log.Fatal("ENVIRONMENT environment variable is not set.")
		return
	} else if environment != "test" && environment != "staging" && environment != "prod" {
		log.Fatal("ENVIRONMENT environment variable should be one of test, staging or prod.")
		return
	}
	clusterName := os.Getenv("CLUSTER_NAME")
	if len(clusterName) == 0 {
		log.Fatal("CLUSTER_NAME environment variable is not set.")
		return
	}
	configMapName := os.Getenv("CONFIG_MAP_NAME")
	if len(configMapName) == 0 {
		log.Fatal("CONFIG_MAP_NAME environment variable is not set.")
		return
	}

	log.Info("Getting the k8s client")
	clientSet, err := k8sClient(clusterName)
	if err != nil {
		log.WithError(err).Fatal("Unable to get the k8s client")
	}
	log.Info("Successfully got the k8s client")

	log.Info("Getting Prometheus server configmap")
	configMap, err := clientSet.CoreV1().ConfigMaps("monitoring").Get(configMapName, metav1.GetOptions{})
	if err != nil {
		log.WithError(err).Fatal("Unable to get the Prometheus server configmap")
	}
	log.Info("Successfully got the Prometheus server configmap")

	data := (configMap.Data["prometheus.yml"])
	configStructure := config{}
	log.Info("Decoding configmap data into structure")
	configDecoded, err := decodeConfig(data, configStructure)
	if err != nil {
		log.WithError(err).Fatal("Unable to decode into struct")
	}
	log.Info("Successfully decoded configmap data into structure")

	log.Info("Getting existing Prometheus Route53 records")
	prometheusRecords, err := getRoute53Records(prometheusHostedZoneID)
	if err != nil {
		log.WithError(err).Fatal("Unable to get the existing Prometheus Route53 records")
	}
	prometheusTargets := getPrometheusTargets(prometheusRecords.ResourceRecordSets)


	log.Info("Getting existing installations Route53 records")
	installationsRecords, err := getRoute53Records(installationsHostedZoneID)
	if err != nil {
		log.WithError(err).Fatal("Unable to get the existing installations Route53 records")
	}
	installationsTargets := getInstallationsTargets(installationsRecords.ResourceRecordSets, environment)


	dataNew, err := updateTargets(configDecoded, prometheusTargets, installationsTargets, environment)
	if err != nil {
		log.WithError(err).Fatal("Unable to update the targets with new ones.")
	}
	configMap.Data["prometheus.yml"] = string([]byte(dataNew))

	_, err = clientSet.CoreV1().ConfigMaps("monitoring").Update(configMap)
	if err != nil {
		log.WithError(err).Fatal("Unable to update Prometheus server configmap")
	}
	log.Info("Successfully updated Prometheus server configmap")
}

// updateTargets is used to replace existing configmap Prometheus targets with new ones
func updateTargets(configData config, prometheusTargets, installationsTargets []string, environment string) ([]byte, error) {
	var prometheusStaticConfigs []staticConfig
	var labels struct {
		ClusterID string `yaml:"clusterID"`
	}
	var s staticConfig

	for _, target := range prometheusTargets {
		clusterID := strings.Split(target, ".")[0]

		labels.ClusterID = clusterID
		s.Targets = []string{target}
		s.Labels = labels
		prometheusStaticConfigs = append(prometheusStaticConfigs, s)
	}

	// Adding the Prometheus Client for the monitoring cluster
	labels.ClusterID = "C&C"
	s.Targets = []string{"mattermost-cm-prometheus-client-server.monitoring:80"}
	s.Labels = labels
	prometheusStaticConfigs = append(prometheusStaticConfigs, s)

	log.Info("Replacing existing Prometheus targets with updated values")
	configData.ScrapeConfigs[0].StaticConfigs = prometheusStaticConfigs

	var installationsStaticConfigs []staticConfig
	var i staticConfig
	for _, target := range installationsTargets {
		if !strings.HasPrefix(target, "_") && !contains(excludedURLs, target){
			t := fmt.Sprintf("%s/api/v4/system/ping", target)
			i.Targets = []string{t}
			installationsStaticConfigs = append(installationsStaticConfigs, i)
		}
	}
	// Adding community targets as they Route53 is defined in other account
	if environment == "staging" {
		i.Targets = []string{
				"community.mattermost.com/api/v4/system/ping",
				"community-daily.mattermost.com/api/v4/system/ping",
				"community-release.mattermost.com/api/v4/system/ping",
			}
	}
	installationsStaticConfigs = append(installationsStaticConfigs, i)
	log.Info("Replacing existing installations targets with updated values")
	configData.ScrapeConfigs[1].StaticConfigs = installationsStaticConfigs
	
	var installationsRelabelConfigs []relabelConfig
	var r relabelConfig
 	r.SourceLabels = []string{"__address__"}
	r.TargetLabel = "__param_target"
	installationsRelabelConfigs = append(installationsRelabelConfigs, r)

	r.SourceLabels = []string{"__param_target"}
	r.TargetLabel = "instance"
	installationsRelabelConfigs = append(installationsRelabelConfigs, r)

	r.TargetLabel = "__address__"
	r.Replacement = "mattermost-cm-blackbox-prometheus-blackbox-exporter.monitoring:9115"
	installationsRelabelConfigs = append(installationsRelabelConfigs, r)
	
	configData.ScrapeConfigs[1].RelabelConfigs = installationsRelabelConfigs

	data, err := yaml.Marshal(&configData)
	if err != nil {
		return nil, err
	}
	log.Info("Updating Prometheus server configmap with new values")
	return data, nil
}

// decodeConfig is used to decode the configmap data into a usable structure
func decodeConfig(data string, C config) (config, error) {
	dataByte := []byte(data)
	err := yaml.Unmarshal(dataByte, &C)
	if err != nil {
		return C, err
	}
	return C, nil
}

// k8sClient is used to get the k8s client
func k8sClient(clusterName string) (*clientset.Clientset, error) {
	session := newSession()

	// Setup the basic EKS cluster info
	cfg := &clusterConfig{
		ClusterName: clusterName,
		Session:     session,
	}

	// Load the rest from AWS using SDK
	err := cfg.loadConfig()
	if err != nil {
		return nil, err
	}

	// Create the Kubernetes client
	client, err := cfg.newClientConfig()
	if err != nil {
		return nil, err
	}

	clientSet, _, err := client.newClientSetWithEmbeddedToken()
	if err != nil {
		return nil, err
	}
	return clientSet, nil
}

// loadConfig is used to load the EKS configuration
func (c *clusterConfig) loadConfig() error {
	svc := eks.New(c.Session)
	input := &eks.DescribeClusterInput{
		Name: aws.String(c.ClusterName),
	}

	log.WithField("cluster", c.ClusterName).Info("Looking up EKS cluster")

	result, err := svc.DescribeCluster(input)
	if err != nil {
		return err
	}

	log.WithField("cluster", c.ClusterName).Info("Found cluster")
	c.MasterEndpoint = *result.Cluster.Endpoint
	c.CertificateAuthorityData = *result.Cluster.CertificateAuthority.Data
	return nil
}

// newClientConfig is used to create the k8s client configuration that will be used for the authenication
func (c *clusterConfig) newClientConfig() (*clientConfig, error) {
	stsAPI := sts.New(c.Session)

	iamRoleARN, err := checkAuth(stsAPI)
	if err != nil {
		return nil, err
	}
	contextName := fmt.Sprintf("%s@%s", getUsername(iamRoleARN), c.ClusterName)

	data, err := base64.StdEncoding.DecodeString(c.CertificateAuthorityData)
	if err != nil {
		return nil, errors.Wrap(err, "decoding certificate authority data")
	}

	log.Info("Creating Kubernetes client config")
	clientConfig := &clientConfig{
		Client: &clientcmdapi.Config{
			Clusters: map[string]*clientcmdapi.Cluster{
				c.ClusterName: {
					Server:                   c.MasterEndpoint,
					CertificateAuthorityData: data,
				},
			},
			Contexts: map[string]*clientcmdapi.Context{
				contextName: {
					Cluster:  c.ClusterName,
					AuthInfo: contextName,
				},
			},
			AuthInfos: map[string]*clientcmdapi.AuthInfo{
				contextName: &clientcmdapi.AuthInfo{},
			},
			CurrentContext: contextName,
		},
		ClusterName: c.ClusterName,
		ContextName: contextName,
		roleARN:     iamRoleARN,
		sts:         stsAPI,
	}
	return clientConfig, nil
}

// newSession creates a new STS session
func newSession() *session.Session {
	config := aws.NewConfig()
	config = config.WithCredentialsChainVerboseErrors(true)

	opts := session.Options{
		Config:                  *config,
		SharedConfigState:       session.SharedConfigEnable,
		AssumeRoleTokenProvider: stscreds.StdinTokenProvider,
	}

	stscreds.DefaultDuration = 30 * time.Minute

	return session.Must(session.NewSessionWithOptions(opts))
}

// checkAuth checks the AWS access
func checkAuth(stsAPI stsiface.STSAPI) (string, error) {
	input := &sts.GetCallerIdentityInput{}
	output, err := stsAPI.GetCallerIdentity(input)
	if err != nil {
		return "", errors.Wrap(err, "checking AWS STS access – cannot get role ARN for current session")
	}
	iamRoleARN := *output.Arn
	log.Debugf("Role ARN for the current session is %s", iamRoleARN)
	return iamRoleARN, nil
}

// getUsername gets the username out of the AWS Lambda role arn
func getUsername(iamRoleARN string) string {
	usernameParts := strings.Split(iamRoleARN, "/")
	if len(usernameParts) > 1 {
		return usernameParts[len(usernameParts)-1]
	}
	return "iam-root-account"
}

// withEmbeddedToken creates a new AWS token
func (c *clientConfig) withEmbeddedToken() (*clientConfig, error) {
	clientConfigCopy := *c

	log.Info("Generating token")

	gen, err := token.NewGenerator()
	if err != nil {
		return nil, err
	}

	tok, err := gen.GetWithSTS(c.ClusterName, c.sts.(*sts.STS))
	if err != nil {
		return nil, err
	}

	x := c.Client.AuthInfos[c.ContextName]
	x.Token = tok

	log.Infof("Successfully generated token")
	return &clientConfigCopy, nil
}

// newClientSetWithEmbeddedToken creates the new k8s client
func (c *clientConfig) newClientSetWithEmbeddedToken() (*clientset.Clientset, *rest.Config, error) {
	clientConfig, err := c.withEmbeddedToken()
	if err != nil {
		return nil, nil, err
	}
	log.Info("Generating k8s client")
	clientSet, config, err := clientConfig.newClientSet()
	if err != nil {
		return nil, nil, err
	}
	log.Infof("Successfully generated client")
	return clientSet, config, err
}

// newClientSet is used by newClientSetWithEmbeddedToken to create the k8s client
func (c *clientConfig) newClientSet() (*clientset.Clientset, *rest.Config, error) {
	clientConfig, err := clientcmd.NewDefaultClientConfig(*c.Client, &clientcmd.ConfigOverrides{}).ClientConfig()
	if err != nil {
		return nil, clientConfig, err
	}

	client, err := clientset.NewForConfig(clientConfig)
	if err != nil {
		return nil, clientConfig, err
	}
	return client, clientConfig, err
}

// getRoute53Records is used to get the existing Route53 Records
func getRoute53Records(hostedZoneID string) (*route53.ListResourceRecordSetsOutput, error) {
	sess, err := session.NewSession(&aws.Config{})
	if err != nil {
		return nil, err
	}

	// Create Route53 service client
	svc := route53.New(sess)

	recordSets, err := svc.ListResourceRecordSets(&route53.ListResourceRecordSetsInput{
		HostedZoneId: aws.String(hostedZoneID),
		StartRecordName: aws.String("c"),
		StartRecordType: aws.String("CNAME"),
	})

	if err != nil {
		return nil, err
	}
	return recordSets, nil
}

// getPrometheusTargets is used to get only Prometheus related Route53 records.
func getPrometheusTargets(recordSets []*route53.ResourceRecordSet) []string {
	prometheusRecords := []string{}
	for _, record := range recordSets {
		if strings.Contains(*record.Name, ".prometheus.internal") {
			prometheusRecords = append(prometheusRecords, *record.Name)
		}
	}
	log.Info("Returning matching Prometheus Route53 records")
	return prometheusRecords
}

// getInstallationsargets is used to get only Installation related Route53 records.
func getInstallationsTargets(recordSets []*route53.ResourceRecordSet, environment string) []string {
	dnsRecordset := ""
	if environment == "test" {
		dnsRecordset = ".test.mattermost.cloud"
	} else if environment == "staging" {
		dnsRecordset = ".staging.cloud.mattermost.com"
	} else if environment == "prod" {
		dnsRecordset = ".cloud.mattermost.com"
	}
	installationsRecords := []string{}
	for _, record := range recordSets {
		if strings.Contains(*record.Name, dnsRecordset) {
			installationsRecords = append(installationsRecords, *record.Name)
		}
	}
	log.Info("Returning matching installation Route53 records")
	return installationsRecords
}

func contains(s []string, e string) bool {
	for _, a := range s {
	   if a == e {
		  return true
	   }
	}
	return false
 }
