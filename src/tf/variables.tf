variable "vpc_id" {
  type        = string
  description = "ID of the VPC where resources will be deployed."
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region where the resources will be deployed."
}

variable "data_engineer_takehome_source_bucket_name" {
  type        = string
  description = "Name of the source S3 bucket."
}

variable "data_engineer_takehome_destination_bucket_name" {
  type        = string
  description = "Name of the destination S3 bucket."
}

