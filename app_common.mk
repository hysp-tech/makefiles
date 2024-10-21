SHELL := /bin/bash
REPO_ROOT := ../../..
TOOLS_FOLDER := ../../tools
DOCKERHUB_REPO ?= docker.internal.hysp.org
TAG ?= dev

include ../../../help.mk
include ../../makefiles/lint.mk


## Image build tasks
Dockerfile: poetry.lock
	@${TOOLS_FOLDER}/generate_poetry_dockerfile

.PHONY: image
image: Dockerfile  ## Build dev image
	docker build $(REPO_ROOT) \
	 -f $(REPO_ROOT)/py/projects/${APP}/Dockerfile \
	 --build-arg DOCKERHUB_REPO=${DOCKERHUB_REPO} \
	 -t ${DOCKERHUB_REPO}/${APP}:${TAG} \
	 -t ${APP}:${TAG}

	@if [ "$(RELEASE)" == "true" ]; then \
		docker tag ${DOCKERHUB_REPO}/${APP}:${TAG} ${DOCKERHUB_REPO}/${APP}:latest; \
	fi 

.PHONY: docker-login
docker-login:
	echo "${DOCKERHUB_PASSWORD}" | docker login ${DOCKERHUB_REPO} --username=${DOCKERHUB_USERNAME} --password-stdin


.PHONY: push
push: image  ## Push the dev image, e.g: make push TAG=dc86914 RELEASE=true
	docker push ${DOCKERHUB_REPO}/${APP}:${TAG}
	@if [ "$(RELEASE)" == "true" ]; then \
		echo "Push to latest dag"; \
		docker push ${DOCKERHUB_REPO}/${APP}:latest; \
	fi 

####### Dev tasks ###########
.PHONY: install
install:  ## Intall app local
	poetry install

.PHONY: run
run:  ## Run the app in compose
	docker-compose up --build

.PHONY: shell
shell:  ## Make a shell to debug the service app
	docker-compose exec app bash

.PHONY: test
test: ## runs unit tests in compose
	docker-compose -f "docker-compose-ci.yml" up unit_tests --build

# The raw test target for docker-compose file to reference
.PHONY: _test
_test:
	poetry run python -m pytest tests

.PHONY: clean
clean: ## removes build artifacts and caches
	find . -name '*.pyc' -exec rm -f {} \;
	find . -name '*.pyo' -exec rm -f {} \;
	rm -fr .mypy_cache
	rm -fr .pytest_cache
	rm -fr *.egg-info
	rm -fr pip-wheel-metadata
