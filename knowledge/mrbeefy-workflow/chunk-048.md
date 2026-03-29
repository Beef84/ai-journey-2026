[Source: Mrbeefy Workflow]

# Copy the dev function_url_domain output
```

**Update `frontend/IaC/terraform.tfvars` with the dev domain, then:**

```bash
cd frontend/IaC
terraform workspace new dev        # first time only
terraform workspace select dev
terraform apply
```

**Get the CloudFront key pair ID** (needed to generate signed cookies):
```bash
terraform output cloudfront_key_pair_id