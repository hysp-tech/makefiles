LINT_WRAPPER := ../../tools/lint_wrapper

.PHONY: lint
lint: mypy pylint flake8 ## run lint checks

.PHONY: flake8
flake8: ## run flake8 check
	@$(LINT_WRAPPER) --flake8

.PHONY: mypy
mypy: ## run mypy check
	@$(LINT_WRAPPER) --mypy

.PHONY: pylint
pylint: ## run pylint check
	@$(LINT_WRAPPER) --pylint

.PHONY: format
format:  black isort## run format

.PHONY: black
black:
	@$(LINT_WRAPPER) --black

.PHONY: isort
isort:
	@$(LINT_WRAPPER) --isort