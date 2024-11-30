.PHONY: docker-compose-build docker-compose-up docker-compose-shell docker-compose-bash

COMPOSE_FILE ?= docker-compose.yml

docker-compose-build:  ## Build the app
	docker compose -f $(COMPOSE_FILE) build $(APP)

docker-compose-up:  ## e.g docker-compose-up APP=api [COMPOSE_FILE=/a/b/c.yml]
	docker compose -f $(COMPOSE_FILE) up --build $(APP) 

docker-compose-shell: # Run shell backend
	docker compose -f $(COMPOSE_FILE) up -d --build shell

docker-compose-bash: docker-compose-shell  ## Connect to a bash within the docker image
	docker compose -f $(COMPOSE_FILE) exec shell bash
