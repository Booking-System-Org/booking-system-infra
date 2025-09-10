# Переменные
COMPOSE_FILE = docker-compose.yaml
PROJECT_NAME := booking_system_infra

RUN := run --rm
DOCKER_COMPOSE := docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME)
DOCKER_COMPOSE_RUN := $(DOCKER_COMPOSE) $(RUN)

.PHONY: start stop restart build install provision install-migrator migration-create migration-run migration-revert env-setup

.NOTPARALLEL: provision
provision: env-setup build install start migration-run

env-setup:
	@if [ ! -f .env ]; then \
		echo "Создание .env файла из env.example..."; \
		cp env.example .env; \
		echo ".env файл создан! Измените переменные если необходимо."; \
	else \
		echo ".env файл уже существует."; \
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

install: install-migrator
install-migrator:
	$(DOCKER_COMPOSE_RUN) db-migrator npm install

# Команды для работы с миграциями
migration-create:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run migration:create ./src/migrator/migrations/$(name)

migration-run:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run migration:run

migration-revert:
	$(DOCKER_COMPOSE_RUN) db-migrator npm run migration:revert
