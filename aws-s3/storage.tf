provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = "cmtr-031bfa7b-bucket-1780745438"

  tags = {
    Project = "cmtr-031bfa7b"
  }
}
