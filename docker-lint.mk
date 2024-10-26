.PHONY: docker-lint docker-fmt

docker-lint:  ## Lint the code folder
	docker compose -f docker-compose-ci.yml up --build lint

docker-fmt:  ## Apply python formatter (will edit the code)
	CURRENT_UID=$$(id -u):$$(id -g) docker compose -f docker-compose-ci.yml up --build fmt
