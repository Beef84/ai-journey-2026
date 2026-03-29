   - Reads documents from the KB S3 bucket  
   - Generates embeddings using Titan V2  
   - Writes vectors to the S3 Vector Store  
   - Updates the vector index  

### **4.3 Retrieval Workflow**
During a chat request:

1. The agent embeds the user query.  
2. The agent queries the vector index.  
3. Relevant documents are returned.  
4. The agent uses retrieved content to generate the final answer.

---

# **5. Agent Lifecycle Workflow**

### **5.1 Agent Definition**
Terraform defines the agent in DRAFT state, including:

- Instruction block  
- Execution role  
- Foundation model  

### **5.2 Alias Lifecycle**
1. CI/CD checks whether the alias exists.  
2. If the alias does not exist, CI/CD creates it.  
3. CI/CD updates Lambda environment variables with:
   - `AGENT_ID`  
   - `AGENT_ALIAS_ID`  

### **5.3 Versioning**
- Bedrock automatically creates implicit versions.  
- Terraform does not manage versions or aliases.  
- CI/CD ensures the alias always points to the correct version.

---

# **6. CI/CD Workflow**

### **6.1 Trigger Conditions**
Pipeline runs on:

- Push to main  
- Manual dispatch  
- KB file changes  
- Lambda code changes  

### **6.2 Pipeline Steps**
1. Build Lambda bundle.  
2. Deploy Terraform.  