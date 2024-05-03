output "source_bucket_arn" {
  value = aws_s3_bucket.data_engineer_takehome_source_bucket.arn
}

output "destination_bucket_arn" {
  value = aws_s3_bucket.data_engineer_takehome_destination_bucket.arn
}

