[Source: Mrbeefy Architecture | Section: 4.2 Lambda IAM Role]

## **4.2 Lambda IAM Role**
Permissions include:

### **Logging**
- `logs:CreateLogGroup`  
- `logs:CreateLogStream`  
- `logs:PutLogEvents`

### **Bedrock Agent Runtime**
- `bedrock:InvokeAgent`  

Lambda does **not** need direct access to S3 or vector store — the agent handles retrieval.

---