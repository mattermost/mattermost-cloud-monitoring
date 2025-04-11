variable "name" {
  type    = string
  default = "pexip"
}

variable "environment" {
  type        = string
  description = "The environment name that pexip will be deployed"
}

variable "public_subnet_id" {
  type        = string
  description = "A public subnet ID"
}

variable "private_subnet_id" {
  type        = string
  description = "A private subnet ID for Pexip management node"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc for the security group of Pexip"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID provided"
}

variable "conference_nodes" {
  type = map(object({
    dns_name   = string
    ec2_type   = string
    private_ip = string
  }))
  description = "Map of conference nodes with their properties"
  default = {
    "random" = {
      dns_name   = "random.mattermost.com"
      ec2_type   = "c6i.large"
      private_ip = "10.0.1.10"
    },
    "example" = {
      dns_name   = "example.mattermost.com"
      ec2_type   = "c6i.xlarge"
      private_ip = "10.0.1.11"
    }
  }
}

variable "management_route53_record_name" {
  type        = string
  description = "The DNS name for the Pexip management node"
}

variable "management_private_ips" {
  type        = list(string)
  description = "List of the private IPs of the Pexip management node"
}

variable "vpn_ips" {
  type        = list(string)
  description = "List of the IPs for the VPN"
}

variable "official_pexip_management_ec2_ami" {
  default     = "ami-06a8e3534fc60c76b"
  type        = string
  description = "The official AMI 686087431763/Pexip Infinity Management Node 37.0.0 (build 80989.0.0)"
}

variable "official_pexip_conference_ec2_ami" {
  default     = "ami-0d48fecb4209bb660"
  type        = string
  description = "The official AMI 686087431763/Pexip Infinity Conference Node 37.0.0 (build 80989.0.0)"
}

variable "custom_management_ec2_ami" {
  type        = string
  description = "Customized with MM configuration Pexip AMI for management node"
}

variable "custom_conference_ec2_ami" {
  type        = string
  description = "Customized with MM configuration Pexip AMI for conference node"
}

variable "management_ec2_type" {
  type        = string
  description = "The EC2 instance type for Pexip management node"
}

variable "ec2_key_pair" {
  type        = string
  description = "The key pair that will be used for ssh to EC2 instances of Pexip nodes"
}

variable "initial_configuration" {
  description = "A boolean variable to control the initial configuration of Pexip setup, when true official AMI will be deployed and key-pairs will be added to EC2 nodes"
  type        = bool
  default     = true
}

variable "elb_ssl_certificate_arn_internal" {
  type        = string
  description = "ARN of the SSL certificate to be used with the internal ELB"
}

variable "elb_ssl_certificate_arn_public" {
  type        = string
  description = "ARN of the SSL certificate to be used with the public ELB"
}
