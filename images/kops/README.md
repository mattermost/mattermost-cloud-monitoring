# KOPS Custom Mattermost Image

To use this packer template please define:

- add the DNS servers in the `resolve.conf` file
- set the `kops_base_image` using the command line to set the variable like `-var 'kops_base_image=xxxx'` or set in the `kops_custom_image.json`
- set the `instance_type` using the command line to set the variable like `-var 'instance_type=xxxx'` or set in the `kops_custom_image.json`
- set the `kops_version` using the command line to set the variable like `-var 'kops_version=xxxx'` or set in the `kops_custom_image.json`
- and set the AWS Keys.
