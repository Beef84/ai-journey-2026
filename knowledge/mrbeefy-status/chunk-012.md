- **Auto‑resizing textarea** that grows with content
- **Consistent padding and spacing**
- **Predictable keyboard behavior**

This makes the UI feel responsive and intuitive during longer prompts.

---

## **4. Message Bubble Redesign**
User and assistant messages have distinct visual treatments derived from the brand palette:

### **User Messages**
- Right-aligned
- Muted teal bubble (`rgba(61,107,107,0.75)`)
- Teal border
- Light teal text

### **Assistant Messages**
- Left-aligned
- Near-black bubble with subtle teal border
- High-readability light text

Both bubble types support Markdown formatting and long-form content.

---

## **5. Brand Identity: Beef AI Software Logo**
The Beef AI Software logo is displayed in the hero section above the page title and used as the browser favicon. The black background was removed from the PNG using a purpose-built Node.js script (`remove-black-bg.mjs`) that makes near-black pixels transparent using only Node.js built-in modules — no npm dependencies.

---

## **6. Dark Theme with Teal Accent Palette**
The entire site now uses a dark theme derived from the logo:

- **Background:** pure black