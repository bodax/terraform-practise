variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "cmtr-031bfa7b"
}

variable "blue_weight" {
  description = "Traffic weight for the Blue environment (0-100)"
  type        = number
  default     = 100
}

variable "green_weight" {
  description = "Traffic weight for the Green environment (0-100)"
  type        = number
  default     = 0
}
