cd frontend/IaC
terraform init
terraform workspace select default
terraform apply
```

After this first successful deploy, the backend pipeline writes `function_url_domain` to SSM on every run. The frontend pipeline reads it from SSM. You never need to copy it manually again.

---

## **9.6 Generate RSA Key Pair for Dev Signed Cookies** *(Dev only)*

> **What this is:** The dev CloudFront distribution rejects all requests that don't carry a valid signed cookie. You sign cookies with your private key. CloudFront verifies them using the public key you upload via Terraform. The private key never leaves your machine — not in the repo, not in AWS.

Run once from any directory. Store the private key in your password manager or a secure local folder.

```bash
# Generate a 2048-bit RSA private key
openssl genrsa -out cf-dev-private.pem 2048

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