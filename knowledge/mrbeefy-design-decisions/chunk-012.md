[Source: Mrbeefy Design Decisions]

## **5.3 Environment Variables**
Lambda receives:

- `AGENT_ID`  
- `AGENT_ALIAS_ID`  

These are updated by CI/CD to avoid Terraform drift.

---

# **6. Bedrock Agent Design Decisions**

## **6.1 Nova Pro for Reasoning**
Nova Pro was selected because:

- Strong reasoning capabilities  
- Fast response times  
- High-quality output for agent workflows