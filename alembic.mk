.PHONY: alembic-init alembic-revision alembic-upgrade docker-alembic-revision docker-alembic-upgrade

alembic-init:  ## inital alembic db env
	alembic init alembic

alembic-revision:  ## Create a new alembic revision file, e.g make alembic-revision REV_LOG="add user table"
	@if [ -z "$(REV_LOG)" ]; then \
		echo "Error: variable REV_LOG is required."; \
		exit 1; \
	fi
	alembic revision --autogenerate -m "$(REV_LOG)"

alembic-upgrade: ## Apply alembic revision, e.g make alembic-upgrade REV=xyz
	@if [ -z "$(REV)" ]; then \
		echo "Error: variable REV is required for the target"; \
		exit 1; \
	fi
	alembic upgrade $(REV)


docker-alembic-revision:
	@if [ -z "$(REV_LOG)" ]; then \
		echo "Error: variable REV_LOG is required."; \
		exit 1; \
	fi
	docker-compose build app 
	docker-compose run app poetry run alembic revision --autogenerate -m "$(REV_LOG)"


docker-alembic-upgrade: 
	@if [ -z "$(REV)" ]; then \
		echo "Error: variable REV is required for the target"; \
		exit 1; \
	fi
	docker-compose run app poetry run alembic upgrade $(REV)