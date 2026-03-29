[Source: Mrbeefy Status | Section: Dedicated KB ingestion]

### **Dedicated KB ingestion**
- Allows rapid iteration on documentation  
- Avoids unnecessary backend deploys  
- Keeps the KB fresh even when the backend is stable  
- Reduces risk by isolating ingestion failures from backend releases  

Together, they create a **dual‑path ingestion model**:

- **Backend deploy → full system refresh**  
- **KB pipeline → documentation‑only refresh**  

This mirrors real‑world AI infra patterns where knowledge updates and infrastructure updates move at different speeds.

---