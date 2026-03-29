OpenSearch Serverless (the other Bedrock KB vector store option) has a minimum cost of ~$700/month for two OCUs. S3 Vector Store has no fixed cost — it charges only for storage and vector operations, which at KB size are negligible.

**Decision:** S3 Vector Store. OpenSearch is cost-prohibitive for personal/portfolio use.

---

## **5.4 Nova Pro Over Claude for Agent Reasoning**

Claude models (Sonnet, Haiku) have higher per-token costs than Nova Pro. At ~$0.0022/request with Nova Pro, Claude Haiku would be slightly cheaper (~$0.0008–0.001/request) but Nova Pro produces higher-quality, more structured responses for agent workflows.

**Decision:** Nova Pro. Quality over marginal per-request savings at this scale.

---

## **5.5 Titan V2 for Embeddings**

Titan V2 is among the cheapest embedding models on Bedrock at $0.00002/1K tokens. The full KB ingestion costs ~$0.001 per run. There is no cost incentive to use a different model, and Titan V2 integrates natively with S3 Vector Store.

**Decision:** Titan V2. Native integration + negligible cost.

---

## **5.6 Single AWS Account with Terraform Workspaces**
