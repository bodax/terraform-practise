variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the Auto Scaling group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where resources are deployed"
}

variable "ssh_sg_id" {
  type        = string
  description = "Security group ID allowing SSH access"
}

variable "private_http_sg_id" {
  type        = string
  description = "Security group ID allowing HTTP from the load balancer"
}

variable "public_http_sg_id" {
  type        = string
  description = "Security group ID allowing public HTTP access"
}

variable "launch_template_name" {
  type        = string
  description = "Name for the EC2 launch template"
}

variable "asg_name" {
  type        = string
  description = "Name for the Auto Scaling group"
}

variable "lb_name" {
  type        = string
  description = "Name for the Application Load Balancer"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}
