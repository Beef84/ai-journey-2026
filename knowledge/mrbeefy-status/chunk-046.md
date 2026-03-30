[Source: Mrbeefy Status | Section: Frontend Paragraph Rendering]

## **Frontend Paragraph Rendering**

Three layered fixes to ensure paragraph spacing actually displays correctly:

1. **Newline normalization** — Single `\n` characters in agent output are normalized to `\n\n` before being passed to ReactMarkdown. ReactMarkdown folds single newlines into spaces; double newlines create `<p>` elements. This ensures the agent's line breaks always produce visual paragraph separation.

2. **Paragraph margin** — `.message p` margin increased to `1em` (one full line height), giving a proper blank-line visual gap between paragraphs.

3. **`white-space: pre-wrap` scoped to user bubbles only** — Previously applied to all message bubbles, causing single `\n` in assistant output to appear as visual line breaks (but without margin). Removing it from assistant bubbles lets ReactMarkdown control all formatting. User bubbles retain `pre-wrap` so Shift+Enter newlines display correctly.

---