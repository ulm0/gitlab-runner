export MAINTAINER:=klud
export NAME:=gitlab-runner
export IMAGE:=$(MAINTAINER)/$(NAME)
export VERSION:=$(shell ./ci/version)
export ARCHS:=armhf

all: version image

help:
	# General commands:
	# make all => image
	# make version - show information about the current version
	#
	# Build commands
	# make image - release images to docker hub and project registry

version: FORCE
	@echo "---"
	@echo Version: $(VERSION)
	@echo Image: $(IMAGE):$(VERSION)
	@echo Platorms: $(ARCHS)
	@echo ""
	@echo Brought to you by ulm0
	@echo "---"

image:
	# Build and push the Docker image
	@./ci/build_and_release

FORCE:
