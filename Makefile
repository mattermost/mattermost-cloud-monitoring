all: lint docs

lint:
## lint: lint all terraform modules
	@echo "Linting all modules"
	bash -c "./scripts/format_lint.sh"

setup:
## setup: install tflint
	@if [ "$(shell uname)" = "Darwin" ]; then \
		echo "Installing tflint using brew on macOS"; \
		brew install tflint; \
	else \
		echo "Installing tflint using install script on Linux"; \
		curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash; \
	fi

plugin:
## installing aws plugin for tflint
	tflint --init --config .tflint.hcl 

docs:
## docs: generate terraform docs for each module
	@echo "Generating Terraform docs for all modules"
	@for d in aws/* ; do \
		echo "Generating docs for $$d"; \
		terraform-docs markdown table $$d > $$d/README.md; \
	done

release-patch:
## release-patch: Creates a new patch release by incrementing the latest tag
	@echo "Creating new patch release..."
	@git checkout master
	@git pull
	@latest_tag=$$(git describe --tags `git rev-list --tags --max-count=1`); \
	if [ -z "$$latest_tag" ]; then \
		echo "No existing tags found"; \
		exit 1; \
	fi; \
	major=$$(echo $$latest_tag | cut -d. -f1); \
	minor=$$(echo $$latest_tag | cut -d. -f2); \
	patch=$$(echo $$latest_tag | cut -d. -f3); \
	new_patch=$$((patch + 1)); \
	new_tag="$$major.$$minor.$$new_patch"; \
	echo "Creating new tag: $$new_tag"; \
	git tag "$$new_tag"; \
	git push origin "$$new_tag"

release-minor:
## release-minor: Creates a new minor release by incrementing the minor version and resetting patch to 0
	@echo "Creating new minor release..."
	@git checkout master
	@git pull
	@latest_tag=$$(git describe --tags `git rev-list --tags --max-count=1`); \
	if [ -z "$$latest_tag" ]; then \
		echo "No existing tags found"; \
		exit 1; \
	fi; \
	major=$$(echo $$latest_tag | cut -d. -f1); \
	minor=$$(echo $$latest_tag | cut -d. -f2); \
	new_minor=$$((minor + 1)); \
	new_tag="$$major.$$new_minor.0"; \
	echo "Creating new tag: $$new_tag"; \
	git tag "$$new_tag"; \
	git push origin "$$new_tag"
