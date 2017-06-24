export MAINTAINER:=klud
export NAME:=gitlab-runner
export IMAGE:=$(MAINTAINER)/$(NAME)
export VERSION:=$(shell ./ci/version)
export ARCHS:=armhf

all: compress release

help:
	# General commands:
	# make all => compress release_docker_image
	# make version - show information about the current version
	#
	# Build commands
	# make compress - download and compress binaries with upx
	#
	# Deploy Commands
	# make release - release images to docker hub and project registry

version: FORCE
	@echo Version: $(VERSION)
	@echo Image: $(IMAGE):$(VERSION)
	@echo Platorms: $(ARCHS)
	@echo ""
	@echo Brought to you by $(MAINTAINER)

compress:
	# Download and compress binaries
	@./ci/compress_binaries

release:
	# Releasing Docker images
	@./ci/release_docker_images

FORCE:
