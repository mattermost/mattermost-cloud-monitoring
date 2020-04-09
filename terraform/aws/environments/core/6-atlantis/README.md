# Atlantis Deployment

All settings are configured via helm chart and can be tweaked in the terraform variables or direclty in the helm values if is not sensitive.

The only setting we are creating manually is the AWS secrets keys, we already have a secret name deployed in the namespace and to add or update the keys just need to change that secret and restart the pods.
