variable "prefix" {
  type        = string
  description = "Resource name prefix (e.g. mrbeefy or mrbeefy-dev)"
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the knowledge S3 bucket"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}
