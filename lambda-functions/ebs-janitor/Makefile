# Golang
HANDLER ?= build/output/_bin/main
PACKAGE ?= $(HANDLER)
GOPATH  ?= $(HOME)/go
GOOS    ?= linux
GOARCH  ?= amd64
GO_TEST_FLAGS ?= -race

# Binary
TAG ?= dev-local
LDFLAGS := -ldflags "-s -w -X main.BuildVersion=$(shell git rev-parse --short HEAD) -X main.BuildTime=$(shell date +%s)"

WORKDIR = $(CURDIR:$(GOPATH)%=/go%)
ifeq ($(WORKDIR),$(CURDIR))
	WORKDIR = /tmp
endif

all: build dist 

.PHONY: build
## build: Builds a linux binary
build:
	@echo "Building..."
	@GOOS=$(GOOS) GOARCH=$(GOARCH) go build ${LDFLAGS} -o $(HANDLER)

.PHONY: clean
## clean: Run golangci-lint on codebase
clean:
	@echo "Cleaning up..."
	@rm -rf $(HANDLER) $(PACKAGE).zip

.PHONY: dist
## dist: packaging binary into zip
dist:
	@echo "Packing binary..."
	@zip $(PACKAGE).zip $(HANDLER)

.PHONY: lint
## lint: Run golangci-lint on codebase
lint:
	@echo "Linting..."
	@if ! [ -x "$$(command -v golangci-lint)" ]; then \
		echo "golangci-lint is not installed. Please see https://github.com/golangci/golangci-lint#install for installation instructions."; \
		exit 1; \
	fi; \

	@echo Running golangci-lint
	golangci-lint run ./...

.PHONY: test
## test: tests all packages
test:
	@echo "Running tests..."
	go test -v $(GO_TEST_FLAGS) ./...

.PHONY: help
## help: prints this help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
