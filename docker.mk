.PHONY: docker-compose-build docker-compose-up docker-compose-shell docker-compose-bash

docker-compose-build:  ## Build the app
	docker compose build

docker-compose-up:  ## Run app with rebuild
	docker compose up --build

docker-compose-shell: # Run shell backend
	docker compose up -d --build shell

docker-compose-bash: docker-compose-shell  ## Connect to a bash within the docker image
	docker compose exec shell bash
