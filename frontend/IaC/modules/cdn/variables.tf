variable "prefix" {
  type        = string
  description = "Resource name prefix (e.g. mrbeefy or mrbeefy-dev)"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for the CloudFront distribution"
}

variable "bucket_regional_domain_name" {
  type        = string
  description = "S3 bucket regional domain name for the CloudFront S3 origin"
}

variable "bucket_arn" {
  type        = string
  description = "S3 bucket ARN used in the bucket policy"
}

variable "bucket_id" {
  type        = string
  description = "S3 bucket ID for attaching the bucket policy"
}

variable "oac_id" {
  type        = string
  description = "CloudFront Origin Access Control ID"
}

variable "function_url_domain" {
  type        = string
  description = "Lambda Function URL domain for the /chat origin (no scheme, no trailing slash)"
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID for the root A record"
}

variable "domain" {
  type        = string
  description = "Public domain name (e.g. mrbeefy.academy)"
}

variable "gateway_secret" {
  type        = string
  sensitive   = true
  description = "Secret injected as x-cloudfront-secret custom header on the API Gateway origin"
}

variable "enable_signed_cookies" {
  type        = bool
  description = "When true, CloudFront requires signed cookies to serve any content (used for dev)"
}

variable "cloudfront_public_key_pem" {
  type        = string
  description = "RSA public key PEM for CloudFront signed cookies (required when enable_signed_cookies is true)"
}
