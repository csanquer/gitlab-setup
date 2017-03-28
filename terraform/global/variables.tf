variable "aws_dns_zone" {
  description = "AWS Route53 zone"
}

variable "bastion_dns_subdomain" {
  description = "Bastion DNS subdomain"
  default     = "bastion1"
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
