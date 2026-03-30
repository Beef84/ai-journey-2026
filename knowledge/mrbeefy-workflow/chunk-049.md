[Source: Mrbeefy Workflow]

# Frontend
cd frontend/IaC
terraform workspace new dev   # first time only
terraform workspace select dev
terraform apply \
  -var="cloudfront_public_key_pem=$(cat /path/to/dev-cf-public.pem)"
```

---