# Frontend S3 bucket (private) and CloudFront Origin Access Control.
# All public access is blocked; CloudFront accesses the bucket via OAC + SigV4.
# The bucket policy granting CloudFront read access lives in the cdn module
# because it requires the distribution ARN, which is created there.

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.prefix}-frontend-${var.suffix}"
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                              = "${var.prefix}-frontend-oac"
  description                       = "OAC for Mr. Beefy frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
