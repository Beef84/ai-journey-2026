variable "prefix" {
  type        = string
  description = "Resource name prefix (e.g. mrbeefy or mrbeefy-dev)"
}

variable "suffix" {
  type        = string
  description = "Random hex suffix for unique S3 bucket name"
}
