variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  description = "List of subnets to create, each with name, CIDR, and availability zone"
}

variable "igw_name" {
  type        = string
  description = "Name tag for the Internet Gateway"
}

variable "route_table_name" {
  type        = string
  description = "Name tag for the route table"
}
