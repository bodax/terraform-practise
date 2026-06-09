variable "vpc_id" {
  type        = string
  description = "VPC ID where the security groups will be created"
}

variable "allowed_ip_range" {
  type        = list(string)
  description = "List of CIDR blocks allowed for SSH and public HTTP ingress"
}

variable "ssh_sg_name" {
  type        = string
  description = "Name for the SSH security group"
}

variable "public_http_sg_name" {
  type        = string
  description = "Name for the public HTTP security group"
}

variable "private_http_sg_name" {
  type        = string
  description = "Name for the private HTTP security group"
}
