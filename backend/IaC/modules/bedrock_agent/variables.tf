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

variable "foundation_model_id" {
  type        = string
  description = "Bedrock foundation model ID (e.g. anthropic.claude-3-5-haiku-20241022-v1:0). The module derives the cross-region inference profile ID from this value."
}
