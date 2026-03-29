output "bucket_id" {
  value       = aws_s3_bucket.frontend.id
  description = "S3 bucket ID"
}

output "bucket_name" {
  value       = aws_s3_bucket.frontend.bucket
  description = "S3 bucket name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.frontend.arn
  description = "S3 bucket ARN"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
  description = "S3 bucket regional domain for CloudFront origin"
}

output "oac_id" {
  value       = aws_cloudfront_origin_access_control.frontend_oac.id
  description = "CloudFront Origin Access Control ID"
}
