[Source: Mrbeefy Design Decisions | Section: 11.5 Explicit, Isolated Ingestion Jobs]

## **11.5 Explicit, Isolated Ingestion Jobs**
The KB pipeline triggers ingestion directly via the Bedrock API.

This ensures:

- Deterministic ingestion  
- Clear failure boundaries  
- No interference with backend deploys  
- A clean, minimal workflow focused solely on knowledge updates  

The backend still performs ingestion during deploys, but the KB pipeline owns ingestion during day‑to‑day updates.

---