[Source: Mrbeefy Design Decisions | Section: 8.1 Least Privilege]

# **8. IAM Design Decisions**

## **8.1 Least Privilege**
Each role has only the permissions required for its function.

### **Lambda Role**
- Logging  
- `bedrock:InvokeAgent`

### **Agent Execution Role**
- Model invocation  
- KB retrieval  
- S3 read access  
- Vector store operations