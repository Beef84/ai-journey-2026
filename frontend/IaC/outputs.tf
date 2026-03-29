output "frontend_bucket_name" {
  description = "S3 bucket name for the frontend assets"
  value       = module.storage.bucket_name
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name for the frontend"
  value       = module.cdn.distribution_domain_name
}
