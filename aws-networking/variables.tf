variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "cmtr-031bfa7b-01-vpc"
}

variable "public_subnets" {
  description = "Public subnets configuration"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      name              = "cmtr-031bfa7b-01-subnet-public-a"
      cidr_block        = "10.10.1.0/24"
      availability_zone = "eu-west-1a"
    },
    {
      name              = "cmtr-031bfa7b-01-subnet-public-b"
      cidr_block        = "10.10.3.0/24"
      availability_zone = "eu-west-1b"
    },
    {
      name              = "cmtr-031bfa7b-01-subnet-public-c"
      cidr_block        = "10.10.5.0/24"
      availability_zone = "eu-west-1c"
    }
  ]
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "cmtr-031bfa7b-01-igw"
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "cmtr-031bfa7b-01-rt"
}
