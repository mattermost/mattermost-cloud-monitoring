HANDLER ?= logs-to-opensearch
PACKAGE ?= $(HANDLER)

all: pack

pack:
	@echo "Packing files..."
	@zip $(PACKAGE).zip ../$(HANDLER)/*.js

clean:
	@echo "Cleaning up..."
	@rm -rf $(PACKAGE).zip

.PHONY: all pack clean
