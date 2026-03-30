[Source: Mrbeefy Workflow | Section: 4.3 Retrieval Workflow]

### **4.3 Retrieval Workflow**
During a chat request:

1. The agent embeds the user query.
2. Lambda passes `numberOfResults: 15` via `sessionState.knowledgeBaseConfigurations` in the `InvokeAgentCommand`.
3. The agent queries the vector index and retrieves up to 15 relevant chunks.
4. The agent uses retrieved content to generate the final answer.

---