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
  # default workspace = prod (keeps existing resource names unchanged).
  # Any other workspace name (e.g. "dev") gets embedded in every resource name
  # so multiple environments can coexist in the same account.
  prefix = terraform.workspace == "default" ? "mrbeefy" : "mrbeefy-${terraform.workspace}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_id" "suffix" {
  byte_length = 4
}

module "knowledge_bucket" {
  source     = "./modules/knowledge_bucket"
  prefix     = local.prefix
  suffix     = random_id.suffix.hex
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

module "bedrock_agent" {
  source     = "./modules/bedrock_agent"
  prefix     = local.prefix
  bucket_arn = module.knowledge_bucket.bucket_arn
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

variable "gateway_secret" {
  type        = string
  sensitive   = true
  description = "Shared secret CloudFront sends as x-cloudfront-secret header; Lambda rejects requests without it"
}

module "lambda_api" {
  source          = "./modules/lambda_api"
  prefix          = local.prefix
  agent_id        = module.bedrock_agent.agent_id
  lambda_zip_path = "${path.module}/../lambda/dist.zip"
  gateway_secret  = var.gateway_secret
}
