.PHONY: docker-compose-lint docker-compose-fmt

docker-compose-lint:  ## Lint the code folder
	docker compose -f docker-compose-ci.yml up --build lint

docker-compose-fmt:  ## Apply python formatter (will edit the code)
	CURRENT_UID=$$(id -u):$$(id -g) docker compose -f docker-compose-ci.yml up --build fmt
