# CloudFront distribution with two origins: S3 (static UI) and API Gateway (/chat).
# Also owns the S3 bucket policy (requires distribution ARN) and the Route53 A alias record.

resource "aws_cloudfront_cache_policy" "frontend" {
  name        = "${var.prefix}-frontend-cache-policy"
  default_ttl = 3600
  max_ttl     = 86400
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config      { cookie_behavior       = "none" }
    headers_config      { header_behavior       = "none" }
    query_strings_config { query_string_behavior = "none" }
  }
}

resource "aws_cloudfront_cache_policy" "api" {
  name        = "${var.prefix}-api-cache-policy"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config      { cookie_behavior       = "none" }
    headers_config      { header_behavior       = "none" }
    query_strings_config { query_string_behavior = "none" }
  }
}

resource "aws_cloudfront_origin_request_policy" "api" {
  name = "${var.prefix}-api-origin-request-policy"

  cookies_config { cookie_behavior = "none" }

  headers_config {
    header_behavior = "whitelist"
    headers         { items = ["Content-Type"] }
  }

  query_strings_config { query_string_behavior = "all" }
}

resource "aws_cloudfront_response_headers_policy" "frontend" {
  name = "${var.prefix}-frontend-security-headers"

  security_headers_config {
    content_type_options { override = true }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "no-referrer-when-downgrade"
      override        = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = false
      preload                    = false
      override                   = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
  }
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  comment             = "${var.prefix} frontend"
  default_root_object = "index.html"
  aliases             = [var.domain]

  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = "${var.prefix}-frontend-origin"
    origin_access_control_id = var.oac_id
  }

  origin {
    domain_name = var.function_url_domain
    origin_id   = "${var.prefix}-api-origin"

    # Secret header proves request came from CloudFront; Lambda rejects anything without it.
    custom_header {
      name  = "x-cloudfront-secret"
      value = var.gateway_secret
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "${var.prefix}-frontend-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id            = aws_cloudfront_cache_policy.frontend.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.frontend.id

    # Require signed cookies on dev; prod is open to the public.
    trusted_key_groups = var.enable_signed_cookies ? [aws_cloudfront_key_group.signed_cookies[0].id] : []
  }

  ordered_cache_behavior {
    path_pattern           = "/chat"
    target_origin_id       = "${var.prefix}-api-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]

    # compress = false is required for streaming — compression forces CloudFront to buffer
    # the full response before forwarding, which breaks SSE chunk delivery.
    compress = false

    cache_policy_id          = aws_cloudfront_cache_policy.api.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.api.id

    trusted_key_groups = var.enable_signed_cookies ? [aws_cloudfront_key_group.signed_cookies[0].id] : []
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }
}

# CloudFront public key and key group for signed cookies — created only for non-prod workspaces.
# The matching private key is kept locally and never committed.
resource "aws_cloudfront_public_key" "signed_cookies" {
  count       = var.enable_signed_cookies ? 1 : 0
  name_prefix = "${var.prefix}-cf-public-key-"
  encoded_key = trimspace(var.cloudfront_public_key_pem)

  # name_prefix ensures each replacement gets a unique name so create_before_destroy
  # can create the new key before the old one is removed from the key group.
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [encoded_key]
  }
}

resource "aws_cloudfront_key_group" "signed_cookies" {
  count = var.enable_signed_cookies ? 1 : 0
  name  = "${var.prefix}-cf-key-group"
  items = [aws_cloudfront_public_key.signed_cookies[0].id]
}

# Bucket policy lives here because it requires the distribution ARN.
data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontOACRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${var.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.frontend.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
}

# Root A record aliased to this distribution.
resource "aws_route53_record" "root" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
