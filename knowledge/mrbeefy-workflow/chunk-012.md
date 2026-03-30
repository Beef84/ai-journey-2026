[Source: Mrbeefy Workflow]

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