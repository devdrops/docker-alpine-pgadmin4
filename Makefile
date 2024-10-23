# ----------------------------------------------------------------------------------------------------------------------
#  Variables and arguments required
SHELL := '/bin/bash'
.DEFAULT_GOAL := help
GIT_LAST_COMMIT_HASH := $(shell git rev-parse --short HEAD)
CURRENT_DATE_GMT := $(shell date +"%Y-%m-%dT%H:%M:%S%Z")
VERSION := $(shell git describe --tags --always)
# ------------------------------------------------------------------------------------------------------
build: ## Generate image. Requires PGADMIN_VERSION and PGADMIN_WHL args.
	docker build \
		--build-arg VCS_REF=$(GIT_LAST_COMMIT_HASH) \
		--build-arg BUILD_DATE=$(CURRENT_DATE_GMT) \
		--build-arg BUILD_VERSION=7.4-xdebug \
		--build-arg VERSION="$(VERSION)" \
		--build-arg PGADMIN_VERSION=$(PGADMIN_VERSION) \
		--build-arg PGADMIN_WHL=$(PGADMIN_WHL) \
		--no-cache \
		-t devdrops/pgadmin4:$(PGADMIN_VERSION) .

help: ## Print information of each Make task.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
# ------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------
.PHONY: help
