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

.PHONY: all config ami ami-gitlab ami-runner plan apply output destroy ssh_host_keys

all:

# generate SSH host keys to be the same on all gitlab instances
#
# prevent ssh client warnings about ssh host keys to be different
# between SSH load balancer
ssh_host_keys:
	if [ ! -f terraform/ssh_host_keys.tar.gz ]; then \
		rm -rf tmp_ssh_host_keys ;\
		mkdir -p tmp_ssh_host_keys ;\
		cd tmp_ssh_host_keys ;\
		ssh-keygen -q -t dsa -N "" -f ssh_host_dsa_key -C "root@gitlab" ;\
		ssh-keygen -q -t rsa -N "" -f ssh_host_rsa_key -C "root@gitlab" ;\
		ssh-keygen -q -t ecdsa -N "" -f ssh_host_ecdsa_key -C "root@gitlab" ;\
		ssh-keygen -q -t ed25519 -N "" -f ssh_host_ed25519_key -C "root@gitlab" ;\
		tar -cvzf ../terraform/ssh_host_keys.tar.gz ssh_host_* ;\
	fi;

config: ssh_host_keys
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
