variable "domain" {
  type        = string
  description = "Domain name for the ACM certificate"
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID for DNS validation records"
}
