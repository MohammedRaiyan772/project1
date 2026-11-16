variable "aws_region" {
  description = "AWS region in which to create the lab resources."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix used for AWS resources."
  type        = string
  default     = "raiyan-motors"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet. Leave empty to let AWS choose."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in aws_region."
  type        = string
}

variable "admin_cidr" {
  description = "Your trusted public IP in CIDR notation, e.g. 203.0.113.10/32. Do not use 0.0.0.0/0 for SSH."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for each Kubernetes node. Choose based on Kubernetes resource requirements and budget."
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}
