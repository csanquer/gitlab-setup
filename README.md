Gitlab HA setup template on AWS
===============================

This template is a POC to setup a [Gitlab](https://about.gitlab.com/) system with [High Availability](https://about.gitlab.com/high-availability/)  on [Amazon Web Service Cloud](https://aws.amazon.com/).

This template is heavily inspired by [Gitlab university : HA on AWS](https://docs.gitlab.com/ce/university/high-availability/aws/).


The project tries to follow Immutable server pattern and Infrastructure-as-Code principles by using :
* [Packer](https://www.packer.io/) to create [Amazon Virtual Machine Images (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
* [Ansible](https://www.ansible.com/) to install and configure packages on these Virtual Machine Images when running Packer
* [Terraform](https://www.terraform.io/) to create and orchestrate the cloud infrastructure
* [cloud-init](https://cloudinit.readthedocs.io/en/latest/) and [jinja2-cli](https://github.com/mattrobenolt/jinja2-cli) to finalize setup automatically when launching AWS instances from AMI
* [Docker](https://www.docker.com/) to run Continuous Integration in containers with [Gitlab-CI](https://about.gitlab.com/gitlab-ci/)


Requirements
------------

* a [AWS account](https://aws.amazon.com/) (**Be careful this template implies creating billable resources on AWS cloud**)
* a [AWS Route 53 DNS zone](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html) already created (the template will add new subdomain DNS A records)
* a SSH Key pair to connect to Gitlab and AWS instances (see [Github help for examples](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/))
* [Packer](https://www.packer.io/) >= 0.12
* [Terraform](https://www.terraform.io/) >= 8.2
* GNU Make or some Unix equivalent Implementation
