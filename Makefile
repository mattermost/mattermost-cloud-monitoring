# Select the environment you want to deploy Central Command Control cluster into.
ENVIRONMENT = test

all: build-app terraform-cluster terraform-post-cluster terraform-route53 clean

build-app:
	$(MAKE) -C ./prometheus-dns-registration-service all

terraform-cluster:
	@echo "Deploying cluster infrastructure"
	cd terraform/aws/environments/$(ENVIRONMENT)/cluster && \
	terraform init && \
	terraform apply --auto-approve

terraform-post-cluster:
	@echo "Deploying cluster post-installation infrastructure"
	cd terraform/aws/environments/$(ENVIRONMENT)/cluster-post-installation && \
	terraform init && \
	terraform apply --auto-approve

terraform-route53:
	@echo "Registering services with Route53"
	cd terraform/aws/environments/$(ENVIRONMENT)/route53-registration && \
	terraform init && \
	terraform apply --auto-approve

clean: 
	$(MAKE) -C ./prometheus-dns-registration-service clean
