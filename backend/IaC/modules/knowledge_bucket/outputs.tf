output "bucket_name" {
  value       = aws_s3_bucket.knowledge.bucket
  description = "S3 bucket name for knowledge files"
}

output "bucket_arn" {
  value       = aws_s3_bucket.knowledge.arn
  description = "S3 bucket ARN"
}

output "kb_role_arn" {
  value       = aws_iam_role.kb_role.arn
  description = "IAM role ARN for knowledge base ingestion"
}
