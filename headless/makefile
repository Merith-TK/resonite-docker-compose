UID := $(shell id -u)

defalt: pull build
	export HOST_UID=$(UID)
	docker compose up -d --remove-orphans
up: pull build
	export HOST_UID=$(UID)
	docker compose up --remove-orphans
down: build
	docker compose down --remove-orphans

build:
	docker compose build
pull:
	docker compose pull

stop: down
start: up
restart: down default

clean-docker:
	docker volume prune
	docker image prune

fix-perms:  set-user
	chmod +x ./.build/scripts/*.sh
	sudo chown $(UID):$(UID) -R ./
set-user:
	# replace the "RUN_AS: *" with "RUN_AS: $(UID)" in the docker-compose.yml
	sed -i 's/RUN_AS: .*/RUN_AS: $(UID)/g' docker-compose.yml