# load local defaults, these file does not get commited
include .make

EXTRAS?=
PWD=$(shell pwd)
FAMILY=management

.DEFAULT_GOAL := help
.PHONY: help

## Prints this help
help:
	@awk 'BEGIN{ doc_mode=0; doc=""; doc_h="" } { \
		if ("##"==$$1 && doc_mode==0) { doc_mode=2 } \
		if (match($$1, /^[%.a-zA-Z_-]+:/) && doc_mode==1) { printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$1, doc_h, doc; doc_mode=0; doc="" } \
		if (doc_mode==1) { $$1=" "; doc=doc "\n" $$0 } \
		if (doc_mode==2) { doc_mode=1; $$1=""; doc_h=$$0 } }' $(MAKEFILE_LIST)

## Builds and Configures VM
vm: vm_build vm_configure

## Builds VM
vm_build:
	cd ansible && ansible-playbook \
		--extra-vars hosts=$(ROLE) \
		--extra-vars pwd=$(PWD) \
		--tags=build \
		$(EXTRAS) \
		playbook/$(FAMILY)/$(ROLE).yml

## Configures VM
vm_configure:
	cd ansible && ansible-playbook \
		--extra-vars hosts=$(ROLE) \
		--extra-vars pwd=$(PWD) \
		--tags=configure \
		$(EXTRAS) \
		playbook/$(FAMILY)/$(ROLE).yml

## Get dependencies
deps:
	ansible-galaxy install -p ansible/roles -r ansible/roles.yml

.make:
	echo "" > .defaults
