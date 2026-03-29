terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  # default workspace = prod (keeps existing resource names and domain unchanged).
  # Any other workspace (e.g. "dev") gets a prefixed subdomain and signed-cookie enforcement.
  prefix               = terraform.workspace == "default" ? "mrbeefy" : "mrbeefy-${terraform.workspace}"
  domain               = terraform.workspace == "default" ? "mrbeefy.academy" : "${terraform.workspace}.mrbeefy.academy"
  enable_signed_cookies = terraform.workspace != "default"
}


variable "function_url_domain" {
  type        = string
  description = "Lambda Function URL domain passed from backend pipeline (no scheme, no trailing slash)"
}

variable "gateway_secret" {
  type        = string
  sensitive   = true
  description = "Shared secret CloudFront sends to API Gateway as x-cloudfront-secret"
}

variable "cloudfront_public_key_pem" {
  type        = string
  default     = ""
  description = "RSA public key PEM used for CloudFront signed cookies (required for dev workspace)"
}

data "aws_route53_zone" "mrbeefy" {
  name         = "mrbeefy.academy"
  private_zone = false
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "certificate" {
  source  = "./modules/certificate"
  domain  = local.domain
  zone_id = data.aws_route53_zone.mrbeefy.zone_id
}

module "storage" {
  source = "./modules/storage"
  prefix = local.prefix
  suffix = random_id.suffix.hex
}

module "cdn" {
  source                      = "./modules/cdn"
  prefix                      = local.prefix
  certificate_arn             = module.certificate.certificate_arn
  bucket_regional_domain_name = module.storage.bucket_regional_domain_name
  bucket_arn                  = module.storage.bucket_arn
  bucket_id                   = module.storage.bucket_id
  oac_id                      = module.storage.oac_id
  function_url_domain         = var.function_url_domain
  zone_id                     = data.aws_route53_zone.mrbeefy.zone_id
  domain                      = local.domain
  gateway_secret              = var.gateway_secret
  enable_signed_cookies        = local.enable_signed_cookies
  cloudfront_public_key_pem   = var.cloudfront_public_key_pem
}
