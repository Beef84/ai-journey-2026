# Creates a Bedrock Knowledge Base with S3 Vectors storage and an S3 data source,
# if one with the given name does not already exist.
# Outputs the KB ID to stdout on the last line — capture it with $(...) or similar.
#
# Parameters:
#   -KbName       Knowledge Base name (e.g. mrbeefy-dev-kb)
#   -KbRoleArn    IAM role ARN for the KB (from Terraform output kb_role_arn)
#   -BucketArn    S3 bucket ARN for the data source (from Terraform output knowledge_bucket_arn)
#   -Region       AWS region (default: us-east-1)
#
# S3 Vectors setup mirrors the prod index config:
#   dimension=1024, distanceMetric=euclidean, dataType=float32
#   nonFilterableMetadataKeys: AMAZON_BEDROCK_TEXT, AMAZON_BEDROCK_METADATA

param(
  [string]$KbName,
  [string]$KbRoleArn,
  [string]$BucketArn,
  [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"
$env:AWS_REGION         = $Region
$env:AWS_DEFAULT_REGION = $Region

# Naming: mrbeefy-dev-kb -> bucket: mrbeefy-dev-vectors, index: bedrock-knowledge-base-default-index
$VectorsBucketName = $KbName -replace '-kb$', '-vectors'
$VectorsIndexName  = "bedrock-knowledge-base-default-index"

# Get account ID
$AccountId = aws sts get-caller-identity --query "Account" --output text
if (-not $AccountId) { Write-Error "Could not determine AWS account ID."; exit 1 }

$VectorsBucketArn = "arn:aws:s3vectors:${Region}:${AccountId}:bucket/${VectorsBucketName}"
$VectorsIndexArn  = "arn:aws:s3vectors:${Region}:${AccountId}:bucket/${VectorsBucketName}/index/${VectorsIndexName}"
$EmbeddingModelArn = "arn:aws:bedrock:${Region}::foundation-model/amazon.titan-embed-text-v2:0"

$TempDir = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } elseif ($env:TEMP) { $env:TEMP } else { "/tmp" }

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
      --region $Region
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create S3 Vectors bucket."; exit 1 }
    Write-Host "S3 Vectors bucket created."
}

# ----------------------------------------------------------------
# Step 2 — ensure the S3 Vectors index exists
# Mirrors the prod index: euclidean distance, float32, 1024 dimensions.
# Bedrock requires an indexArn when creating the KB via API.
# ----------------------------------------------------------------
$IndexExists = aws s3vectors get-index `
  --vector-bucket-name $VectorsBucketName `
  --index-name $VectorsIndexName `
  --query "index.indexName" `
  --output text 2>$null

if ($IndexExists -and $IndexExists -ne "None") {
    Write-Host "S3 Vectors index '$VectorsIndexName' already exists."
} else {
    Write-Host "Creating S3 Vectors index '$VectorsIndexName'..."

    $CreateIndexInput = @{
        vectorBucketName = $VectorsBucketName
        indexName        = $VectorsIndexName
        dataType         = "float32"
        dimension        = 1024
        distanceMetric   = "euclidean"
        metadataConfiguration = @{
            nonFilterableMetadataKeys = @("AMAZON_BEDROCK_TEXT", "AMAZON_BEDROCK_METADATA")
        }
    } | ConvertTo-Json -Depth 10 -Compress

    $IndexInputFile = "$TempDir/create_index_input.json"
    [System.IO.File]::WriteAllText($IndexInputFile, $CreateIndexInput, (New-Object System.Text.UTF8Encoding $false))

    aws s3vectors create-index `
      --cli-input-json "file://$IndexInputFile" `
      --region $Region | Out-Null

    Remove-Item $IndexInputFile -ErrorAction SilentlyContinue
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create S3 Vectors index."; exit 1 }
    Write-Host "S3 Vectors index created: $VectorsIndexArn"
}

# ----------------------------------------------------------------
# Step 3 — ensure the Knowledge Base exists
# Uses indexArn (bucket/index) which is what the Bedrock API requires.
# ----------------------------------------------------------------
$KB_ID = aws bedrock-agent list-knowledge-bases `
  --query "knowledgeBaseSummaries[?name=='$KbName'] | [0].knowledgeBaseId" `
  --output text

if ($KB_ID -and $KB_ID -ne "None") {
    Write-Host "Knowledge Base '$KbName' already exists: $KB_ID"
} else {
    Write-Host "Creating Knowledge Base '$KbName'..."

    $CreateKbInput = @{
        name    = $KbName
        roleArn = $KbRoleArn
        knowledgeBaseConfiguration = @{
            type = "VECTOR"
            vectorKnowledgeBaseConfiguration = @{
                embeddingModelArn = $EmbeddingModelArn
            }
        }
        storageConfiguration = @{
            type = "S3_VECTORS"
            s3VectorsConfiguration = @{
                indexArn = $VectorsIndexArn
            }
        }
    } | ConvertTo-Json -Depth 10 -Compress

    $KbInputFile = "$TempDir/create_kb_input.json"
    [System.IO.File]::WriteAllText($KbInputFile, $CreateKbInput, (New-Object System.Text.UTF8Encoding $false))

    $KbJson = aws bedrock-agent create-knowledge-base `
      --cli-input-json "file://$KbInputFile" `
      --output json | ConvertFrom-Json

    Remove-Item $KbInputFile -ErrorAction SilentlyContinue

    if ($LASTEXITCODE -ne 0 -or -not $KbJson.knowledgeBase.knowledgeBaseId) {
        Write-Error "Failed to create Knowledge Base."
        exit 1
    }

    $KB_ID = $KbJson.knowledgeBase.knowledgeBaseId
    Write-Host "Knowledge Base created: $KB_ID"
}

# ----------------------------------------------------------------
# Step 4 — ensure a data source exists
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

    $CreateDsInput = @{
        knowledgeBaseId = $KB_ID
        name            = "$KbName-source"
        dataSourceConfiguration = @{
            type = "S3"
            s3Configuration = @{
                bucketArn = $BucketArn
            }
        }
        vectorIngestionConfiguration = @{
            chunkingConfiguration = @{
                chunkingStrategy = "NONE"
            }
        }
    } | ConvertTo-Json -Depth 10 -Compress

    $DsInputFile = "$TempDir/create_ds_input.json"
    [System.IO.File]::WriteAllText($DsInputFile, $CreateDsInput, (New-Object System.Text.UTF8Encoding $false))

    aws bedrock-agent create-data-source `
      --cli-input-json "file://$DsInputFile" `
      --output json | Out-Null

    Remove-Item $DsInputFile -ErrorAction SilentlyContinue

    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create data source."; exit 1 }
    Write-Host "Data source created."
}

# Output KB ID for pipeline capture
Write-Output $KB_ID
