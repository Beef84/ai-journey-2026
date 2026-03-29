variable "prefix" {
  type        = string
  description = "Resource name prefix (e.g. mrbeefy or mrbeefy-dev)"
}

variable "suffix" {
  type        = string
  description = "Random hex suffix for unique resource names"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}
