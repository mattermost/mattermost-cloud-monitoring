# AWS EKS Custom Mattermost Image

To use this packer template please define:

- add the DNS servers in the `resolv.conf` file
- set the `eks_base_image` using the command line to set the variable like `-var 'eks_base_image=xxxx'` or set in the `eks_custom_image.json`
- set the `instance_type` using the command line to set the variable like `-var 'instance_type=xxxx'` or set in the `eks_custom_image.json`
- set the `eks_version` using the command line to set the variable like `-var 'eks_version=xxxx'` or set in the `eks_custom_image.json`
- and set the AWS Keys.
