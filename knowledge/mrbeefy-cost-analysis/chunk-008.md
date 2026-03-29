Multi-account setups provide stronger isolation but add cross-account IAM complexity and potential inter-account data transfer costs. For a personal project, workspaces in a single account provide sufficient isolation (separate state, separate resource names) with zero overhead.

**Decision:** Single account + workspaces. Cost and complexity overhead of multi-account is not justified.

---

# **6. Cost Controls and Best Practices**

## **6.1 Current Controls**
- No per-user rate limiting — all requests hit Bedrock directly
- No request caching — every unique question hits Nova Pro
- No spend alerts configured

## **6.2 Recommended Controls**

| Control | Mechanism | Cost Impact |
|---|---|---|
| AWS Budget alert | Set at $10/month, alert at 80% | No cost, early warning |
| Lambda reserved concurrency | Cap concurrent Lambda invocations | Limits runaway usage |
| CloudWatch anomaly detection | Alert on unusual Lambda invocation spikes | No cost |

At personal/portfolio scale, the risk of unexpected cost is low — a viral moment hitting 10,000 chats in a month would cost ~$23, which is acceptable. Budgets and alerts are still good hygiene.

## **6.3 What Would Drive Costs Up**
