variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_public_a_name" {
  description = "Name of public subnet in AZ a"
  type        = string
}

variable "subnet_public_a_cidr" {
  description = "CIDR block for public subnet in AZ a"
  type        = string
}

variable "subnet_public_b_name" {
  description = "Name of public subnet in AZ b"
  type        = string
}

variable "subnet_public_b_cidr" {
  description = "CIDR block for public subnet in AZ b"
  type        = string
}

variable "subnet_public_c_name" {
  description = "Name of public subnet in AZ c"
  type        = string
}

variable "subnet_public_c_cidr" {
  description = "CIDR block for public subnet in AZ c"
  type        = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "route_table_name" {
  description = "Name of the public route table"
  type        = string
}
