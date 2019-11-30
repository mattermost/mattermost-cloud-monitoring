APPVERSION = 0.0.1
APPBIN  ?= bin/cloud-manager
GOFLAGS = -mod=vendor -ldflags '-X main.BuildVersion=$(APPVERSION)'

export GO111MODULE=on

all: build

.PHONY: build
build:
	@echo "Building cloud-manager..."
	@CGO_ENABLED=0 go build $(GOFLAGS) -o $(APPBIN) github.com/mattermost/mattermost-cloud-monitoring/cloud-manager/cmd/cloud-manager

.PHONY: run
run: build
	@echo "Running cloud-manager..."
	@ $(APPBIN)

.PHONY: clean
clean:
	@$(RM) bin/cloud-manager