.PHONY: docker-ci-shell docker-ci-bash

docker-ci-shell: # Create CI shell backend
	docker compose -f docker-compose-ci.yml up --build -d shell

docker-ci-bash: ci-shell  # Connect to a bash within the tool image(faster), for running task like `poetry lock`
	docker compose -f docker-compose-ci.yml exec shell bash


