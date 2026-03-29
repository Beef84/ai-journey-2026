variable "prefix" {
  type        = string
  description = "Resource name prefix (e.g. mrbeefy or mrbeefy-dev)"
}

variable "agent_id" {
  type        = string
  description = "Bedrock Agent ID to invoke"
}

variable "lambda_zip_path" {
  type        = string
  description = "Absolute path to the Lambda dist.zip artifact"
}

variable "gateway_secret" {
  type        = string
  sensitive   = true
  description = "Secret CloudFront injects as x-cloudfront-secret; Lambda rejects requests without it"
}
