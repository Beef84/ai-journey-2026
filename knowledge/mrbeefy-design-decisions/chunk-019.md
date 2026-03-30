[Source: Mrbeefy Design Decisions | Section: 7.4 Retrieval Count: 15]

## **7.4 Retrieval Count: 15**
The Lambda `InvokeAgentCommand` passes `numberOfResults: 15` via `sessionState.knowledgeBaseConfigurations`. The default (without explicit config) was lower, which caused the agent to miss relevant chunks on multi-part questions. 15 results provides enough surface area for the agent to reason over without exceeding Claude 3.5 Haiku's context window at typical chunk sizes.

---