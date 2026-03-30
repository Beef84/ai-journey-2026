[Source: Mrbeefy Status | Section: What Changed > CloudFront Key Rotation Fix]

### **CloudFront Key Rotation Fix**
The `aws_cloudfront_public_key` resource previously used `name`, which caused a replace-destroy cycle to fail with `PublicKeyAlreadyExists` (409) or `PublicKeyInUse` (409) depending on lifecycle ordering. Fixed by switching to `name_prefix` with `create_before_destroy = true`. Terraform now creates a uniquely named replacement key before destroying the old one, breaking the circular dependency.