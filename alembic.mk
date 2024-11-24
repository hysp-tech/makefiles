.PHONY: alembic-init alembic-revision alembic-upgrade

DB_APP ?= app

alembic-init:  ## inital alembic db env
	alembic init alembic

alembic-revision:  ## Create a new alembic revision file[within a docker app env], e.g make alembic-revision REV_LOG="add user table" DB_APP=app
	@if [ -z "$(REV_LOG)" ]; then \
		echo "Error: variable REV_LOG is required."; \
		exit 1; \
	fi

	docker-compose build $(DB_APP) 
	docker-compose run $(DB_APP) alembic revision --autogenerate -m "$(REV_LOG)"


alembic-upgrade: ## Apply alembic revision, e.g make alembic-upgrade REV=xyz DB_APP=app
	@if [ -z "$(REV)" ]; then \
		echo "Error: variable REV is required for the target"; \
		exit 1; \
	fi
	docker-compose run $(DB_APP) alembic upgrade $(REV)