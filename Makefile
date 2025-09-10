# Переменные
COMPOSE_FILE = docker-compose.yaml
PROJECT_NAME := booking_system_infra

RUN := run --rm
DOCKER_COMPOSE := docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME)
DOCKER_COMPOSE_RUN := $(DOCKER_COMPOSE) $(RUN)

.PHONY: start stop restart build install provision migration-create migration-run migration-revert env-setup seed

.NOTPARALLEL: provision
provision: env-setup build install start migration-run seed

env-setup:
	@if [ ! -f .env ]; then \
		echo "Creating .env file from env.example..."; \
		cp env.example .env; \
		echo ".env file created! Change variables if necessary."; \
	else \
		echo ".env file already exists."; \
	fi

start:
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d --force-recreate

build:
	$(DOCKER_COMPOSE) build --no-cache --force-rm

clean:
	$(DOCKER_COMPOSE) down -v

install:
	$(DOCKER_COMPOSE_RUN) db-migrator npm install

# Команды для работы с миграциями
migration-create:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run migration:create ./src/migrator/migrations/$(name)

migration-run:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run migration:run

migration-revert:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run migration:revert

seed:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run seed
