# set default shell
SHELL := $(shell which bash)
ENV = /usr/bin/env
# default shell options
.SHELLFLAGS = -c

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
default: all;   # default target

.PHONY: all config ami ami-gitlab ami-runner plan apply output destroy

all:

config:
	cp -n -v packer/config.dist.json packer/config.json
	cp -n -v terraform/terraform.dist.tfvars terraform/terraform.tfvars

ami: ami-gitlab ami-runner

ami-gitlab: config
	cd packer
	packer build -var-file=config.json gitlab.json

ami-runner: config
	cd packer
	packer build -var-file=config.json gitlab-ci-runner.json

plan: config
	cd terraform
	terraform plan

apply: config
	cd terraform
	terraform apply

output: config
	cd terraform
	terraform output

destroy: config
	cd terraform
	terraform destroy
