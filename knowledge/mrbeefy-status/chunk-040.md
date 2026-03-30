[Source: Mrbeefy Status | Section: What Changed]

## **What Changed**

### **Standalone Chunker (`scripts/chunker.py`)**
The 90-line inline Python in `wiki-sync.yml` was extracted into a reusable script with a new two-pass merge algorithm:

- **Pass 1** builds sections per heading with full hierarchy context prefixes (unchanged behavior)
- **Pass 2** merges header-only and undersized sections (< 200 chars) forward into the next sibling — eliminating useless heading-only chunks
- Merges never cross `##` boundaries, preserving major topic groupings
- `MAX_CHARS` raised from 1500 → 2000 to give Bedrock more context per retrieved chunk
- CLI flags: `--wiki-dir`, `--out-dir`, `--max-chars`, `--min-chars`, `--overlap`