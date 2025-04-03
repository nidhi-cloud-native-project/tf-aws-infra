variable "profile" {
  description = "AWS profile name"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "custom_ami_id" {
  description = "Custom AMI ID built with Packer"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "ssh_key_name" {
  description = "SSH key name for accessing EC2"
  type        = string
}

variable "db_password" {
  description = "Password for RDS DB"
  type        = string
  sensitive   = true
}

variable "ssh_cidr_block" {
  description = "CIDR block allowed to SSH into EC2 (usually your own IP /32)"
  type        = string
}

variable "root_domain" {
  description = "The root domain name"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route 53 Hosted Zone ID (for demo or dev subdomain)"
  type        = string
}