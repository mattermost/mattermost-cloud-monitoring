# Select the environment you want to deploy Central Command Control cluster into.
ENVIRONMENT = test


all: build-app terraform-cluster terraform-post-cluster clean

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

clean: 
	$(MAKE) -C ./prometheus-dns-registration-service clean
