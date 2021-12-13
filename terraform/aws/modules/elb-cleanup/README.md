### Overview
 
This terraform module can be used to create lambda with configurable AWS cloudwatch event rule (default is 7 days).
It automatically cleans up the unused elbs & classic load balancers.
 
### Usage Example
 
```hcl
module "elb-cleanup" {
 source             = "github.com/mattermost/mattermost-cloud-monitoring/terraform/aws/modules/elb-cleanup"
 private_subnet_ids = var.private_subnet_ids
 vpc_id             = var.vpc_id
 deployment_name    = var.deployment_name
 bucket             = var.bucket
 elb_cleanup_lambda_schedule  = "rate(7 days)"
 dryrun             = "true"
}
```
 
Note: Dry Run is a configurable environment variable which facilitates finding & listing unused ELBs & classic load balancers without deleting them.
