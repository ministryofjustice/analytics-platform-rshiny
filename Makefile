SHELL = '/bin/bash'
export IMAGE_TAG ?= local
export DOCKER_BUILDKIT?=1
export REPOSITORY?=rshiny
export REGISTRY?=593291632749.dkr.ecr.eu-west-1.amazonaws.com
export NETWORK?=default
export CHEF_LICENSE=accept-no-persist

.PHONY: build pull push clean up logs enter test

pull:
	docker-compose pull rshiny

build:
	docker buildx bake --load -f ./docker-compose.yml

push:
	docker-compose push rshiny

# test: clean up
# 	echo Testing Container Version: ${IMAGE_TAG}
# 	docker-compose run --rm inspec exec tests -t docker://${REPOSITORY}_rshiny_1

clean:
	docker-compose down --volumes --remove-orphans

up:
	docker-compose up -d 

logs:
	docker-compose logs -f rshiny

enter:
	docker-compose exec rshiny bash