[Source: Mrbeefy Design Decisions | Section: 5.2 Minimal Responsibility]

## **5.2 Minimal Responsibility**
Lambda does not:

- Perform retrieval  
- Perform embeddings  
- Manage KB ingestion  
- Manage agent versions  

Lambda only:

- Accepts user input  
- Calls Bedrock Agent Runtime  
- Returns the response  

This keeps the function small, predictable, and low-maintenance.