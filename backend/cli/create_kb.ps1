# Creates a Bedrock Knowledge Base with S3 Vectors storage and an S3 data source,
# if one with the given name does not already exist.
# Outputs the KB ID to stdout on the last line — capture it with $(...) or similar.
#
# Parameters:
#   -KbName       Knowledge Base name (e.g. mrbeefy-dev-kb)
#   -KbRoleArn    IAM role ARN for the KB (from Terraform output kb_role_arn)
#   -BucketArn    S3 bucket ARN for the data source (from Terraform output knowledge_bucket_arn)
#   -Region       AWS region (default: us-east-1)

param(
  [string]$KbName,
  [string]$KbRoleArn,
  [string]$BucketArn,
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"
$env:AWS_REGION         = $Region
$env:AWS_DEFAULT_REGION = $Region

# Derive S3 Vectors bucket name from KB name: mrbeefy-kb -> mrbeefy-vectors
$VectorsBucketName = $KbName -replace '-kb$', '-vectors'

# Get account ID
$AccountId = aws sts get-caller-identity --query "Account" --output text
if (-not $AccountId) { Write-Error "Could not determine AWS account ID."; exit 1 }

$VectorsBucketArn  = "arn:aws:s3vectors:${Region}:${AccountId}:bucket/${VectorsBucketName}"
$EmbeddingModelArn = "arn:aws:bedrock:${Region}::foundation-model/amazon.titan-embed-text-v2:0"

# ----------------------------------------------------------------
# Step 1 — ensure the S3 Vectors bucket exists
# ----------------------------------------------------------------
$BucketExists = aws s3vectors get-vector-bucket `
  --vector-bucket-name $VectorsBucketName `
  --region $Region `
  --query "vectorBucket.vectorBucketName" `
  --output text 2>$null

if ($BucketExists -and $BucketExists -ne "None") {
    Write-Host "S3 Vectors bucket '$VectorsBucketName' already exists."
} else {
    Write-Host "Creating S3 Vectors bucket '$VectorsBucketName'..."
    aws s3vectors create-vector-bucket `
      --vector-bucket-name $VectorsBucketName `
      --region $Region | Out-Null
    Write-Host "S3 Vectors bucket created."
}

# ----------------------------------------------------------------
# Step 2 — ensure the Knowledge Base exists
# ----------------------------------------------------------------
$KB_ID = aws bedrock-agent list-knowledge-bases `
  --query "knowledgeBaseSummaries[?name=='$KbName'] | [0].knowledgeBaseId" `
  --output text

if ($KB_ID -and $KB_ID -ne "None") {
    Write-Host "Knowledge Base '$KbName' already exists: $KB_ID"
} else {
    Write-Host "Creating Knowledge Base '$KbName'..."

    $KbConfig = @{
        type = "VECTOR"
        vectorKnowledgeBaseConfiguration = @{
            embeddingModelArn = $EmbeddingModelArn
        }
    } | ConvertTo-Json -Compress

    $StorageConfig = @{
        type = "S3_VECTORS"
        s3VectorsConfiguration = @{
            bucketArn = $VectorsBucketArn
        }
    } | ConvertTo-Json -Compress

    $KbJson = aws bedrock-agent create-knowledge-base `
      --name $KbName `
      --role-arn $KbRoleArn `
      --knowledge-base-configuration $KbConfig `
      --storage-configuration $StorageConfig `
      --output json | ConvertFrom-Json

    $KB_ID = $KbJson.knowledgeBase.knowledgeBaseId
    Write-Host "Knowledge Base created: $KB_ID"
}

# ----------------------------------------------------------------
# Step 3 — ensure a data source exists
# Chunking strategy is NONE because we manage chunk boundaries ourselves.
# ----------------------------------------------------------------
$DS_ID = aws bedrock-agent list-data-sources `
  --knowledge-base-id $KB_ID `
  --query "dataSourceSummaries[0].dataSourceId" `
  --output text

if ($DS_ID -and $DS_ID -ne "None") {
    Write-Host "Data source already exists: $DS_ID"
} else {
    Write-Host "Creating data source for '$KbName'..."

    $DsConfig = @{
        type = "S3"
        s3Configuration = @{
            bucketArn = $BucketArn
        }
    } | ConvertTo-Json -Compress

    $VectorIngestionConfig = @{
        chunkingConfiguration = @{
            chunkingStrategy = "NONE"
        }
    } | ConvertTo-Json -Compress

    aws bedrock-agent create-data-source `
      --knowledge-base-id $KB_ID `
      --name "$KbName-source" `
      --data-source-configuration $DsConfig `
      --vector-ingestion-configuration $VectorIngestionConfig `
      --output json | Out-Null

    Write-Host "Data source created."
}

# Output KB ID for pipeline capture
Write-Output $KB_ID
