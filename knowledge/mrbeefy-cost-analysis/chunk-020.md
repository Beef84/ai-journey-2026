[Source: Mrbeefy Cost Analysis | Section: 6.2 Recommended Controls]

## **6.2 Recommended Controls**

| Control | Mechanism | Cost Impact |
|---|---|---|
| AWS Budget alert | Set at $10/month, alert at 80% | No cost, early warning |
| Lambda reserved concurrency | Cap concurrent Lambda invocations | Limits runaway usage |
| CloudWatch anomaly detection | Alert on unusual Lambda invocation spikes | No cost |

At personal/portfolio scale, the risk of unexpected cost is low — a viral moment hitting 10,000 chats in a month would cost ~$23, which is acceptable. Budgets and alerts are still good hygiene.