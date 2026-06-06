variable "project_tag" {
  type        = string
  description = "Project tag value used for resource tagging"
  default     = "cmtr-031bfa7b"
}

variable "allowed_ip_range" {
  type        = list(string)
  description = "List of IP ranges allowed to access the infrastructure"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
  default     = "vpc-0869569d5c635b35a"
}

variable "public_subnet_id" {
  type        = string
  description = "ID of the public subnet"
  default     = "subnet-0419e172cd5b7228c"
}

variable "private_subnet_id" {
  type        = string
  description = "ID of the private subnet"
  default     = "subnet-001b5f9491e43336e"
}

variable "public_instance_id" {
  type        = string
  description = "ID of the public EC2 instance"
  default     = "i-0605bc9a921721a73"
}

variable "private_instance_id" {
  type        = string
  description = "ID of the private EC2 instance"
  default     = "i-09d5c083939466fad"
}
