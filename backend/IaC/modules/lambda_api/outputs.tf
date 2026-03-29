output "function_url_domain" {
  value       = trimsuffix(trimprefix(aws_lambda_function_url.api.function_url, "https://"), "/")
  description = "Lambda Function URL domain (no scheme, no trailing slash) for CloudFront API origin"
}

output "function_name" {
  value       = aws_lambda_function.api.function_name
  description = "Lambda function name"
}
