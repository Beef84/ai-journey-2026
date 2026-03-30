[Source: Mrbeefy Workflow]

# Generate a 2048-bit RSA private key
openssl genrsa -out dev-cf-private.pem 2048

# Extract the public key from it
openssl rsa -pubout -in dev-cf-private.pem -out dev-cf-public.pem
```

**Add the public key as a GitHub secret:**

Go to: **GitHub repo → Settings → Secrets and Variables → Actions → New repository secret**

| Secret Name | Value |
|---|---|
| `DEV_CF_PUBLIC_KEY` | Full contents of `dev-cf-public.pem` (including `-----BEGIN PUBLIC KEY-----` header/footer) |

The CI/CD frontend pipeline reads this secret and passes it to Terraform when deploying the dev environment.

> `dev-cf-public.pem` is not a secret — it goes into CloudFront via Terraform. `dev-cf-private.pem` is a secret — keep it safe and never commit it. The repo `.gitignore` excludes all `*.pem` files.

---