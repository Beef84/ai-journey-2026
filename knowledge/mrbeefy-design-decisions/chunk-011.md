- **Permanent Marker** (Google Fonts) — used for the page title and section headings. Matches the brush-lettered style of the logo text.
- **Nunito** — used for body text, input, and button labels. Clean and friendly, complements the display font without competing with it.

---

## **12.7 Message Bubble Design**
User and assistant messages have distinct visual treatments:

- **User:** right-aligned, teal-tinted bubble with teal border
- **Assistant:** left-aligned, dark bubble with subtle teal border

Both support Markdown formatting and long-form content.

---

## **12.8 Minimal Scrollbar**
A modern, unobtrusive scrollbar with a teal thumb matches the accent palette without drawing attention.

---

# **13. Security Design Decisions**

## **13.1 Lambda Function URL Protection: CloudFront Secret Header**

The raw Lambda Function URL (`https://{id}.lambda-url.us-east-1.on.aws`) is publicly reachable by default. Anyone who discovers the URL can POST to it and invoke Bedrock directly, bypassing CloudFront entirely.
