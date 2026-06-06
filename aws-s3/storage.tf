provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name

  tags = {
    Project = var.project_tag
  }
}