.PHONY: pre-commit-install
pre-commit-install:  ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@pre-commit install
	@echo "Pre-commit hooks installed successfully!"

.PHONY: pre-commit-run
pre-commit-run:  ## Run pre-commit hooks on all files
	@echo "Running pre-commit hooks on all files..."
	@pre-commit run --all-files

### Terraform Formatting & Linting ###

.PHONY: terraform-fmt
terraform-fmt:  ## Format all terraform files
	@echo "Formatting terraform files..."
	@find terraform -name "*.tf" -o -name "*.tfvars" | xargs -I {} dirname {} | sort -u | xargs -I {} terraform fmt {}
	@echo "Terraform formatting complete!"

.PHONY: terraform-lint
terraform-lint:  ## Run tflint on all terraform directories
	@echo "Running tflint on terraform directories..."
	@for dir in $$(find terraform -name "*.tf" | xargs -I {} dirname {} | sort -u); do \
		echo "Linting $$dir..."; \
		cd $$dir && tflint && cd - > /dev/null; \
	done
	@echo "Terraform linting complete!"

.PHONY: fmt
fmt: terraform-fmt  ## Run all formatters (terraform, etc.)
	@echo "All formatting complete!"

.PHONY: lint
lint: pre-commit-run  ## Run all linters (pre-commit hooks)
	@echo "All linting complete!"