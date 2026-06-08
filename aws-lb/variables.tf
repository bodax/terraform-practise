variable "aws_region" {
  description = "AWS region where resources are created"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance type used by the launch template"
  type        = string
  default     = "t3.micro"
}

variable "project_id" {
  description = "Project identifier used to name and tag resources"
  type        = string
  default     = "cmtr-031bfa7b"
}
