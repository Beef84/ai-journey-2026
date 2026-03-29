output "knowledge_bucket" {
  value       = module.knowledge_bucket.bucket_name
  description = "S3 bucket name used for knowledge files"
}

output "knowledge_bucket_arn" {
  value       = module.knowledge_bucket.bucket_arn
  description = "S3 bucket ARN used in IAM policies"
}

output "kb_role_arn" {
  value       = module.knowledge_bucket.kb_role_arn
  description = "IAM role ARN used by the knowledge base ingestion service"
}

output "agent_id" {
  value       = module.bedrock_agent.agent_id
  description = "Bedrock Agent ID (DRAFT agent created by Terraform)"
}

output "function_url_domain" {
  value       = module.lambda_api.function_url_domain
  description = "Lambda Function URL domain for CloudFront API origin"
}

output "function_name" {
  value       = module.lambda_api.function_name
  description = "Lambda function name for CLI and CI/CD env var updates"
}
