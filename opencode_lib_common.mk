SHELL := /bin/bash
REPO_ROOT := ../..
TOOLS_FOLDER := ../../tools
TAG ?= dev

include ../../makefiles/help.mk
include ../../makefiles/lint.mk

.PHONY: install
install: ## install all dependencies
	$(MAKE) --quiet -C ../.. install

.PHONY: test
test: install ## run unit tests
	poetry run pytest


.PHONY: release
release: ## publish a new release
	../release_poetry_package