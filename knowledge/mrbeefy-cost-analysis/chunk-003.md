[Source: Mrbeefy Cost Analysis | Section: 1.1 Amazon Bedrock — Nova Pro (Dominant Cost)]

## **1.1 Amazon Bedrock — Nova Pro (Dominant Cost)**

Nova Pro is the primary cost driver. It is charged per token regardless of caching or streaming.

| Metric | Rate |
|---|---|
| Input tokens | ~$0.0008 / 1K tokens |
| Output tokens | ~$0.0032 / 1K tokens |

**Per chat request estimate:**

A typical exchange involves:
- ~300 tokens: system instruction block
- ~800 tokens: KB context retrieved by the agent
- ~100 tokens: user message
- ~400 tokens: agent response

| Component | Tokens | Cost |
|---|---|---|
| Input (prompt + context) | ~1,200 | ~$0.00096 |
| Output (response) | ~400 | ~$0.00128 |
| **Per request total** | | **~$0.0022** |

Richer KB content and longer conversations increase this. Complex multi-turn queries can reach $0.005–$0.01 per exchange.

---