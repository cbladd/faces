provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "data_engineer_takehome_source_bucket" {
  bucket = var.data_engineer_takehome_source_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket" "data_engineer_takehome_destination_bucket" {
  bucket = var.data_engineer_takehome_destination_bucket_name
  acl    = "private"
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name   = "s3_access_policy"
  role   = aws_iam_role.s3_access_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.data_engineer_takehome_source_bucket.arn,
      "${aws_s3_bucket.data_engineer_takehome_source_bucket.arn}/*",
      aws_s3_bucket.data_engineer_takehome_destination_bucket.arn,
      "${aws_s3_bucket.data_engineer_takehome_destination_bucket.arn}/*",
    ]
  }
}

