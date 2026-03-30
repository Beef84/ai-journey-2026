[Source: Mrbeefy Cost Analysis | Section: 1.2 Amazon Bedrock — Titan V2 Embeddings (KB Ingestion)]

## **1.2 Amazon Bedrock — Titan V2 Embeddings (KB Ingestion)**

Titan V2 is used only during KB ingestion, not during chat.

| Metric | Rate |
|---|---|
| Embedding tokens | ~$0.00002 / 1K tokens |

**Per ingestion run:**
- Current KB: ~267 chunks × ~1,500 chars each ≈ ~100,000 tokens
- Cost per ingestion: ~$0.002

Even running ingestion daily, this is **~$0.04/month** — essentially free.

---