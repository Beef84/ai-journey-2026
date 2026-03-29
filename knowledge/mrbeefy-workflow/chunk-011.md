-----END PUBLIC KEY-----
EOT
```

> `cf-dev-public.pem` is not a secret — it goes into CloudFront via Terraform. `cf-dev-private.pem` is a secret — keep it safe and never commit it.

---

## **9.7 Deploy the Dev Environment** *(Dev only)*

The dev workspace creates a fully isolated parallel stack (`mrbeefy-dev-*`) at `dev.mrbeefy.academy`. Follow the same backend-first order as prod.

**Backend dev:**
```bash
cd backend/IaC
terraform workspace new dev        # first time only — skip if already exists
terraform workspace select dev
terraform apply
terraform output function_url_domain
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
# Copy this value for step 9.8
```

---

## **9.8 Generate a Signed Cookie for Browser Access** *(Dev only)*
