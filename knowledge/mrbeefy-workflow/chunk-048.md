[Source: Mrbeefy Workflow]

# Backend first
cd backend/IaC
terraform workspace new dev   # first time only
terraform workspace select dev
terraform apply