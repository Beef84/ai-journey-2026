[Source: Mrbeefy Workflow]

# Extract the public key from it
openssl rsa -pubout -in cf-dev-private.pem -out cf-dev-public.pem
```

Now open `cf-dev-public.pem` and paste its entire contents into `frontend/IaC/terraform.tfvars`:

```hcl
gateway_secret      = "your-secret"
function_url_domain = ""
cloudfront_public_key_pem = <<EOT
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhki...
(full contents of cf-dev-public.pem)
-----END PUBLIC KEY-----
EOT
```

> `cf-dev-public.pem` is not a secret — it goes into CloudFront via Terraform. `cf-dev-private.pem` is a secret — keep it safe and never commit it.

---