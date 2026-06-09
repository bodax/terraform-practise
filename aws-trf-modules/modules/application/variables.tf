variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ssh_sg_id" {
  type = string
}

variable "private_http_sg_id" {
  type = string
}

variable "public_http_sg_id" {
  type = string
}

variable "launch_template_name" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
