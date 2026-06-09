variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
}

variable "igw_name" {
  type = string
}

variable "route_table_name" {
  type = string
}
