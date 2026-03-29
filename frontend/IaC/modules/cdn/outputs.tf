output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.frontend.domain_name
  description = "CloudFront distribution domain name"
}

output "distribution_hosted_zone_id" {
  value       = aws_cloudfront_distribution.frontend.hosted_zone_id
  description = "CloudFront hosted zone ID (for Route53 alias records)"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.frontend.arn
  description = "CloudFront distribution ARN"
}
