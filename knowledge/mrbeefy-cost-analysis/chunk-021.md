[Source: Mrbeefy Cost Analysis | Section: 6.3 What Would Drive Costs Up]

## **6.3 What Would Drive Costs Up**

- **Long conversations:** Each turn accumulates more input tokens (conversation history fed to agent). A 10-turn conversation could be 3–5× the per-request cost of a single-turn exchange.
- **Large KB:** More retrieved context per query = more input tokens per request. Current KB size keeps context lean.
- **High traffic:** Bedrock scales linearly. There are no volume discounts at this scale.

---