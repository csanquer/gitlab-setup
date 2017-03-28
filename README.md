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

  You will need an [AWS access key](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and enough admin permissions to create AWS ressources
* a [AWS Route 53 DNS zone](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html) already created (the template will add new subdomain DNS A records)
* a SSH Key pair to connect to Gitlab and AWS instances (see [Github help for examples](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/))
* [Packer](https://www.packer.io/) >= 0.12
* [Terraform](https://www.terraform.io/) >= 8.2
* GNU Make or some Unix equivalent Implementation
* *(optional)* [Graphiz](http://www.graphviz.org/) to generate Terraform config Graph Images 
  ```sh
  # on ubuntu/debian
  sudo apt-get install graphviz
  ```


Usage
-----

### To create the Gitlab infrastructure

1. Copy and edit the configuration files :

  * **terraform** : `terraform/terraform.dist.tvars` to `terraform/terraform.tvars`
  * **packer** : `packer/config.dist.json` to `packer/config.json`
  
2. create Amazon Machine Images :

  * Gitlab 
  * Gitlab-CI-multirunner 

  ```sh
  make ami
  ```
  
3. check Terraform plan 

  ```sh
  make plan
  ```

3. if terraform plan is correct, create AWS resources by applying the terraform plan

  ```sh
  make apply
  ```

  * you can check again the terraform exported variables output
    ```sh
    make output
    ```
  * you can also get Graphviz graphs of all terraform config
    ```sh
    # in PNG image format
    make graphs
    # or in SVG
    make graphs format=svg
    ```

After creation, wait for a few minutes the autoscaled gitlab instances finish self initialization.

if variables are set in `terraform/terraform.tvars` like :
```hcl
aws_dns_zone = "my-aws.net"
gitlab_dns_subdomain = "gitlab"
```

The Gitlab server should be available to http://gitlab.my-aws.net/ 

### To destroy the Gitlab infrastructure 

```sh
make destroy
```
