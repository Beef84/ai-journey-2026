[Source: Mrbeefy Status | Section: What Changed > Knowledge Base Auto-Bootstrap (`backend/cli/create_kb.ps1`)]

### **Knowledge Base Auto-Bootstrap (`backend/cli/create_kb.ps1`)**
The `deploy-backend` CI/CD pipeline now auto-creates the Bedrock Knowledge Base for any environment where it does not yet exist. The script is idempotent:

1. Creates the S3 Vectors bucket (euclidean, float32, 1024 dimensions)
2. Creates the vector index with the correct metadata keys
3. Creates the Bedrock Knowledge Base using `indexArn`
4. Creates the data source with `chunkingStrategy = NONE`

All steps use `--cli-input-json file://` with temp files to avoid PowerShell JSON quoting issues. UTF-8 encoding uses `New-Object System.Text.UTF8Encoding $false` to suppress the BOM that breaks the AWS CLI JSON parser.