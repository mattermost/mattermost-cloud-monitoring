all: lint

lint:
## lint: lint all terraform modules
	@echo "Linting all modules"
	bash -c "./scripts/format_lint.sh"

setup:
## setup: install tflint
	curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

plugin:
## installing aws plugin for tflint
	tflint --init --config .tflint.hcl 
