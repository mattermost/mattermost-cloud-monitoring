variable "deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for launch configuration"
}

variable "atlantis_deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for ASG"
}

variable "kubeconfig_dir" {
  type        = string
  description = "The directory where the generated kubeconfig will be appended by terraform provider"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}

variable "org_whitelist" {
  type        = string
  description = "The organization whitelist for git repositories which will be observed by atlantis"
}

variable "gitlab_user" {
  type        = string
  description = "The gitlab user which will be used by Atlantis to get webhook events"
}

variable "gitlab_token" {
  type        = string
  description = "The gitlab token which will be used by Atlantis to get webhook events"
}

variable "gitlab_webhook_secret" {
  type        = string
  description = "The gitlab secret which will be used by Atlantis to get webhook events"
}

variable "gitlab_hostname" {
  type        = string
  description = "The gitlab root hostname eg. gitlab.com"
}

variable "atlantis_hostname" {
  type        = string
  description = "The atlantis hostname eg. atlantis.foo.com"
}

variable "aws_secretname" {
  type        = string
  description = "The atlantis secret name which will be used to provide the necessary credentials profiles for terraform"
}

variable "nginx_internal_chart_values_directory" {
  type        = string
  description = "The nginx helm values directory which will be used to deploy an nginx along with it"
}

variable "atlantis_chart_values_directory" {
  type        = string
  description = "The atlantis helm values directory"
}

variable "atlantis_chart_version" {
  type        = string
  description = "The atlantis helm chart version which will be deployed in kubernetes"
}

variable "terraform_default_version" {
  type        = string
  description = "The terraform default version which Atlantis will use for terraform binary"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID which will be used for the launch configuration where will deploy the Atlantis UI"
}

variable "instance_type" {
  type        = string
  description = "The instance type will be used for launch configuration and ASG"
}

variable "key_name" {
  type        = string
  description = "The SSH key name to use for accessing the ASG nodes"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID for the ASG and the VPC zones"
}

variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "min_size" {
  type        = number
  description = "The minimum number of nodes for ASG"
}

variable "max_size" {
  type        = number
  description = "The maximum number of nodes for ASG"
}

variable "volume_size" {
  type        = string
  description = "The root block device volume size for launch configuration of Atlantis UI"
}

variable "security_groups" {
  type        = list(string)
  description = "The attached security group ID list for launch configuration of Atlantis UI"
}
