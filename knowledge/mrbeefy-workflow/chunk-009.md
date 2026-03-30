[Source: Mrbeefy Workflow]

# **4. Knowledge Base Workflow**

### **4.1 KB File Management**
KB files are generated from the GitHub wiki using a standalone two-pass chunker (`scripts/chunker.py`):

**Pass 1 — Build sections:** Parses each wiki page by heading, capturing the full heading hierarchy as a context prefix (`[Source: X | Section: Y]`) on every chunk.

**Pass 2 — Merge undersized sections:** Sections below 200 content characters are merged forward into the next sibling. Header-only sections (heading line with no body) are always merged. Merges never cross `##` boundaries. After merging, the prefix is promoted to the common ancestor heading.

Constants: `MAX_CHARS = 2000`, `MIN_CONTENT_CHARS = 200`, `OVERLAP_CHARS = 150`.

The chunker is called by `wiki-sync.yml` on every wiki update:
```bash
python3 scripts/chunker.py --wiki-dir wiki --out-dir knowledge
```

It is also reusable by other projects via `--wiki-dir` and `--out-dir` flags.