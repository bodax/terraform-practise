variable "prefix" {
  type        = string
  description = "Prefix used for naming IAM resources"
  default     = "cmtr-031bfa7b"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = "cmtr-031bfa7b-bucket-1780746868"
}

variable "project_tag" {
  type        = string
  description = "Project tag value used for resource tagging"
  default     = "cmtr-031bfa7b"
}