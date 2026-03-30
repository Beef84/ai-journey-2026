[Source: Mrbeefy Design Decisions | Section: 7.3 Two-Pass Chunker (`scripts/chunker.py`)]

## **7.3 Two-Pass Chunker (`scripts/chunker.py`)**
The chunker uses a two-pass algorithm to produce high-quality chunks:

- **Pass 1** splits markdown by heading, building `[Source: X | Section: Y]` context prefixes from the full heading hierarchy — so every chunk knows exactly where in the document it came from.
- **Pass 2** merges undersized sections forward. Header-only sections and sections with fewer than 200 content chars are absorbed into the next sibling. This eliminates useless heading-only chunks without losing context.
- Merges never cross `##` boundaries, preserving major topic groupings.
- `MAX_CHARS = 2000` (up from 1500) gives Bedrock more context per retrieved chunk.