[Source: Mrbeefy Architecture | Section: 10.1 Workspace Naming]

## **10.1 Workspace Naming**
All resource names are prefixed by workspace:
- prod: `mrbeefy-*`
- dev: `mrbeefy-dev-*`

State is automatically isolated: prod state lives at `global/terraform.tfstate`, dev at `env:/dev/global/terraform.tfstate`.