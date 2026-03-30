[Source: Mrbeefy Design Decisions | Section: 8.1 Least Privilege]

### **Lambda Role**
- Logging  
- `bedrock:InvokeAgent`

### **Agent Execution Role**
- Model invocation  
- KB retrieval  
- S3 read access  
- Vector store operations

### **KB Role**
- S3 read  
- s3vectors operations  
- Titan embedding model invocation