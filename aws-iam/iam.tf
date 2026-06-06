provider "aws" {
  region = "eu-west-1"
}

# ----------------------------
# IAM Group
# ----------------------------
resource "aws_iam_group" "iam_group" {
  name = "cmtr-031bfa7b-iam-group"
}

# ----------------------------
# IAM Policy (S3 WRITE ONLY to existing bucket)
# ----------------------------
resource "aws_iam_policy" "iam_policy" {
  name = "cmtr-031bfa7b-iam-policy"

  policy = templatefile("${path.module}/policy.json", {
    bucket_name = "cmtr-031bfa7b-bucket-1780746868"
  })

  tags = {
    Project = "cmtr-031bfa7b"
  }
}

# Attach policy to IAM Group (required for access control)
resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  group      = aws_iam_group.iam_group.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

# ----------------------------
# IAM Role (EC2 assume role)
# ----------------------------
resource "aws_iam_role" "iam_role" {
  name = "cmtr-031bfa7b-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = "cmtr-031bfa7b"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

# ----------------------------
# IAM Instance Profile
# ----------------------------
resource "aws_iam_instance_profile" "instance_profile" {
  name = "cmtr-031bfa7b-iam-instance-profile"
  role = aws_iam_role.iam_role.name

  tags = {
    Project = "cmtr-031bfa7b"
  }
}