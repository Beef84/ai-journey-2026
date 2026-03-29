Only new or updated files are uploaded, preserving the integrity of the vector store.

---

## **11.5 Explicit, Isolated Ingestion Jobs**
The KB pipeline triggers ingestion directly via the Bedrock API.

This ensures:

- Deterministic ingestion  
- Clear failure boundaries  
- No interference with backend deploys  
- A clean, minimal workflow focused solely on knowledge updates  

The backend still performs ingestion during deploys, but the KB pipeline owns ingestion during day‑to‑day updates.

---

# **12. Frontend UI Design Decisions**

## **12.1 Rich Response Rendering**
Markdown rendering was added to support:

- Bold
- Lists
- Headings
- Multi-paragraph responses

This improves readability and matches modern LLM output patterns.

---

## **12.2 Auto-Scrolling**
The chat scrolls automatically to the latest message, improving conversational flow and eliminating manual scrolling after long responses.

---

## **12.3 Improved Input Behavior**
The input box supports:

- Enter → send
- Shift+Enter → newline
- Auto-resizing

These changes align with modern chat UX expectations and make multi-line prompts natural to write.

---

## **12.4 Brand Identity: Beef AI Software Logo**