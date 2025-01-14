.PHONY: docker-ci-shell docker-ci-bash docker-test docker-int-test

# Default to use 'docker-compose-ci.yml'
CI_DOCKER_COMPOSE_FILE := docker-compose-ci.yml

docker-ci-shell: # Create CI shell backend
	docker compose -f $(CI_DOCKER_COMPOSE_FILE) up --build -d shell

docker-ci-bash: ci-shell  # Connect to a bash within the tool image(faster), for running task like `poetry lock`
	docker compose -f $(CI_DOCKER_COMPOSE_FILE) exec shell bash

docker-test: ## Run unit test, e.g make docker-test TEST_FILES='./a/x.py ./a/y.py', default to run all tests.
	@echo "Running unit tests..."
	docker compose -f $(CI_DOCKER_COMPOSE_FILE) build test
	docker compose -f $(CI_DOCKER_COMPOSE_FILE) run --rm -e TEST_FILES=$(TEST_FILES) test

docker-test-int: ## Run integration test
	@echo "Running integration tests..."
	docker compose -f $(CI_DOCKER_COMPOSE_FILE) build test-int
	docker compose -f $(CI_DOCKER_COMPOSE_FILE) run --rm -e TEST_FILES=$(TEST_FILES) test-int