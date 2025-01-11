.PHONY: docker-ci-shell docker-ci-bash docker-test docker-int-test

docker-ci-shell: # Create CI shell backend
	docker compose -f docker-compose-ci.yml up --build -d shell

docker-ci-bash: ci-shell  # Connect to a bash within the tool image(faster), for running task like `poetry lock`
	docker compose -f docker-compose-ci.yml exec shell bash

docker-test: ## Run unit test
	@echo "Running unit tests..."
	docker compose -f docker-compose-ci.yml up --build -d
	docker compose -f docker-compose-ci.yml run --rm -e TEST_FILES=$(TEST_FILES) test
	docker compose -f docker-compose-ci.yml down

docker-test-int: ## Run integration test
	@echo "Running integration tests..."
	docker compose -f docker-compose-ci.yml up --build -d
	docker compose -f docker-compose-ci.yml run --rm -e TEST_FILES=$(TEST_FILES) test-int
	docker compose -f docker-compose-ci.yml down