variable "aws_region" {
  description = "The AWS region where resources are located"
  type        = string
  default     = "eu-west-1"
}

variable "project_id" {
  description = "The project identifier used for tagging"
  type        = string
  default     = "cmtr-031bfa7b"
}

variable "vpc_name" {
  description = "The name of the VPC to discover"
  type        = string
  default     = "cmtr-031bfa7b-vpc"
}

variable "public_subnet_name" {
  description = "The name of the public subnet to discover"
  type        = string
  default     = "cmtr-031bfa7b-public-subnet-1"
}

variable "security_group_name" {
  description = "The name of the security group to discover"
  type        = string
  default     = "cmtr-031bfa7b-sg"
}
