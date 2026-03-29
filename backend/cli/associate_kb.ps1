param(
  [string]$AgentId,
  [string]$KbId
)

# Always associate with DRAFT — versioning is handled separately after this step.
$AgentVersion = "DRAFT"

# Check if the KB is already associated
$EXISTS = aws bedrock-agent list-agent-knowledge-bases `
  --agent-id $AgentId `
  --agent-version $AgentVersion `
  --query "agentKnowledgeBaseSummaries[?knowledgeBaseId=='$KbId'] | length(@)" `
  --output text

if ($EXISTS -eq 1) {
    Write-Host "Knowledge Base $KbId is already associated with agent $AgentVersion. Skipping."
    exit 0
}

Write-Host "Associating Knowledge Base $KbId with agent $AgentVersion..."

aws bedrock-agent associate-agent-knowledge-base `
  --agent-id $AgentId `
  --agent-version $AgentVersion `
  --knowledge-base-id $KbId `
  --description "Primary KB association for mrbeefy agent" `
  --knowledge-base-state ENABLED

Write-Host "KB association completed."
