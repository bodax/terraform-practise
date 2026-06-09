variable "region" {
  type        = string
  description = "AWS region to deploy resources into"
  default     = "eu-west-1"
}

variable "allowed_ip_range" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access SSH and HTTP endpoints"
}
