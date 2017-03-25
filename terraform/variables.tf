variable "aws_access_key" {}
variable "aws_secret_key" {}

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

variable "aws_az1" {
  description = "AWS EC2 availability zone 2"
  default     = "eu-west-1a"
}

variable "aws_az2" {
  description = "AWS EC2 availability zone 2"
  default     = "eu-west-1b"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public1_subnet_cidr" {
  description = "CIDR for the Public 1 Subnet"
  default     = "10.0.0.0/24"
}

variable "public2_subnet_cidr" {
  description = "CIDR for the Public 2 Subnet"
  default     = "10.0.2.0/24"
}

variable "private1_subnet_cidr" {
  description = "CIDR for the Private 1 Subnet"
  default     = "10.0.1.0/24"
}

variable "private2_subnet_cidr" {
  description = "CIDR for the Private 2 Subnet"
  default     = "10.0.3.0/24"
}

variable "sg_ssh_cidr" {
  description = "CIDR allowed for SSH connection to public subnet"
  default     = "0.0.0.0/0"
}

variable "admin_ssh_public_key" {
  description = "SSH public key to connect to EC2 instances"
}

variable "gitlab_static_instances" {
  description = "Gitlab static instances number"
  default     = 0
}

variable "gitlab_max" {
  description = "Gitlab autoscale maximum instance number"
  default     = 3
}

variable "gitlab_min" {
  description = "Gitlab autoscale minimum instance number"
  default     = 1
}

variable "gitlab_desired" {
  description = "Gitlab autoscale desired instance number"
  default     = 2
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
