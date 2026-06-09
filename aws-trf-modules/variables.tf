variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "allowed_ip_range" {
  type = list(string)
}
