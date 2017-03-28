# set default shell
SHELL := $(shell which bash)
ENV = /usr/bin/env
# default shell options
.SHELLFLAGS = -c
SSH_KEY_COMMENT = "root@gitlab"
format = png
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
	if [ ! -f terraform/gitlab/ssh_host_keys.tar.gz ]; then \
		echo "generating Gitlab ssh host keys";\
		rm -rf tmp_ssh_host_keys ;\
		mkdir -p tmp_ssh_host_keys ;\
		cd tmp_ssh_host_keys ;\
		ssh-keygen -q -t dsa -N "" -f ssh_host_dsa_key -C $(SSH_KEY_COMMENT) ;\
		ssh-keygen -q -t rsa -N "" -f ssh_host_rsa_key -C $(SSH_KEY_COMMENT) ;\
		ssh-keygen -q -t ecdsa -N "" -f ssh_host_ecdsa_key -C $(SSH_KEY_COMMENT) ;\
		ssh-keygen -q -t ed25519 -N "" -f ssh_host_ed25519_key -C $(SSH_KEY_COMMENT) ;\
		tar -cvzf ../terraform/gitlab/ssh_host_keys.tar.gz ssh_host_* ;\
		cd .. ;\
		rm -rf tmp_ssh_host_keys ;\
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

_get_modules: config
	cd terraform
	terraform get

plan: _get_modules
	cd terraform
	terraform plan

apply: _get_modules
	cd terraform
	terraform apply

refresh: _get_modules
	cd terraform
	terraform refresh

output: _get_modules
	cd terraform
	terraform output

_graph_dir: _get_modules
	mkdir -p graphs

_graph:
	cd terraform
	terraform graph -type=$(type) -draw-cycles | dot -T$(format) > ../graphs/infra_$(type).$(format)

graphs: _graph_dir
	make _graph type=plan format=$(format)
	make _graph type=plan-destroy format=$(format)
	make _graph type=apply format=$(format)
	make _graph type=validate format=$(format)
	make _graph type=input format=$(format)
	make _graph type=refresh format=$(format)
	echo "Graphs exported to graphs directory"

destroy: _get_modules
	cd terraform
	terraform destroy
