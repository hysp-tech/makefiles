.PHONY: pre-commit-install
pre-commit-install:  ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@pre-commit install
	@echo "Pre-commit hooks installed successfully!"

.PHONY: pre-commit-run
pre-commit-run:  ## Run pre-commit hooks on all files
	@echo "Running pre-commit hooks on all files..."
	@pre-commit run --all-files