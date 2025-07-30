# Makefile for building Docker image and locking requirements

# Variables
DOCKER_IMAGE_NAME := openlab

# Default target
.PHONY: all
all: lock build

# Build Docker image
.PHONY: build-% build
TARGETS := vscode notebook datascience torch jax nlp cv
build-%: 
	@echo "Building Docker image: $(DOCKER_IMAGE_NAME)"
	docker build -t $(DOCKER_IMAGE_NAME):$* --target $* .
build: $(addprefix build-, $(TARGETS))

requirements.txt: requirements.in
	uv pip compile $< -o $@ --python-platform linux

requirements%.txt: requirements%.in
	uv pip compile $< -o $@ --python-platform linux

DEP_FILES = $(wildcard requirements*.in)
LOCK_FILES = $(DEP_FILES:.in=.txt)

.PHONY: lock
lock: $(LOCK_FILES)
