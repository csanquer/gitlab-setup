variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  description = "AWS EC2 Region for the VPC"
  default     = "eu-west-1"
}

variable "admin_ssh_public_key" {
  description = "SSH public key to connect to EC2 instance"
}

variable "aws_dns_zone" {
  description = "AWS Route53 zone"
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
