variable "aws_region" {
  description = "AWS EC2 Region for the VPC"
  default     = "eu-west-1"
}

variable "aws_dns_zone" {
  description = "AWS Route53 zone"
}

variable "gitlab_dns_subdomain" {
  description = "AWS Route53 zone"
  default     = "gitlab"
}

variable "gitlab_max" {
  description = "Gitlab maximum instance number"
  default     = 3
}

variable "gitlab_min" {
  description = "Gitlab minimum instance number"
  default     = 1
}

variable "gitlab_desired" {
  description = "Gitlab desired instance number"
  default     = 2
}

variable "gitlab_data_mountpoint" {
  description = "Gitlab NFS mount point directory to be shared between instances"
  default     = "/gitlab-data"
}

variable "gitlab_db_name" {
  description = "Gitlab database name"
  default     = "gitlab"
}

variable "gitlab_db_username" {
  description = "Gitlab database username"
  default     = "gitlab"
}

variable "gitlab_db_password" {
  description = "Gitlab database password"
}

variable "gitlab_root_password" {
  description = "Gitlab Root account initial password"
}

variable "gitlab_ci_registration_token" {
  description = "Gitlab initial CI registration token"
}

variable "gitlab_secret_bucket" {
  description = "Gitlab secret bucket name"
  default     = "gitlab-init-secret"
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
