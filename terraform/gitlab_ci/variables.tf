variable "gitlab_host" {
  description = "Gitlab DNS hostname"
}

variable "gitlab_init_bucket" {
  description = "AWS Gitlab Init S3 bucket name"
}

variable "gitlab_ci_registration_token" {
  description = "Gitlab initial CI registration token"
}

variable "admin_ssh_key" {
  description = "AWS EC2 Admin ssh key pair name"
}
variable "vpc_id" {}
variable "dns_zone_id" {}
variable "dns_zone_name" {}
variable "sg_bastions_id" {}
variable "private_subnet_ids" {}
variable "public_subnet_ids" {}
