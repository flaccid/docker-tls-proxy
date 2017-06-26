DOCKER_REGISTRY = index.docker.io
IMAGE_NAME = tls-proxy
IMAGE_VERSION = latest
IMAGE_ORG = flaccid
IMAGE_TAG = $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

WORKING_DIR := $(shell pwd)

.DEFAULT_GOAL := build

.PHONY: build push

release:: build push ## Builds and pushes the docker image to the registry

push:: ## Pushes the docker image to the registry
		@docker push $(IMAGE_TAG)

build:: ## Builds the docker image locally
		@echo http_proxy=$(HTTP_PROXY) http_proxy=$(HTTPS_PROXY)
		@docker build --pull \
		--build-arg=http_proxy=$HTTP_PROXY \
		--build-arg=https_proxy=$HTTPS_PROXY \
		-t $(IMAGE_TAG) $(WORKING_DIR)

# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## This help target
	@cat .banner
	@echo
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
