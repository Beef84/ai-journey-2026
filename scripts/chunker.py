#!/usr/bin/env python3
# chunker.py — Two-pass markdown chunker for Bedrock knowledge bases.
#
# Pass 1 (build_sections): Parse markdown into sections by heading, capturing
#   the full heading hierarchy as a context prefix per section.
# Pass 2 (merge_sections): Merge header-only or undersized sections forward
#   into the next sibling, staying within the same H2 boundary.
#
# Usage:
#   python scripts/chunker.py --wiki-dir wiki --out-dir knowledge
#   python scripts/chunker.py --wiki-dir wiki --out-dir knowledge \
#       --max-chars 2000 --min-chars 200 --overlap 150
#
# Reusable: pass different --wiki-dir / --out-dir for other projects.

import argparse
import os
import re

MAX_CHARS = 2000
MIN_CONTENT_CHARS = 200
OVERLAP_CHARS = 150


def heading_level(line):
    m = re.match(r'^(#{1,6})\s', line)
    return len(m.group(1)) if m else 0


def strip_md_bold(text):
    return re.sub(r'\*+', '', text).strip()


def build_sections(text, page_display):
    """
    Pass 1: Split markdown into sections, one per heading boundary.

    Each section dict contains:
      prefix       — [Source: ... | Section: ...] context string
      body         — full text including the opening heading line
      h2           — current H2 heading text (None if no H2 yet); used as
                     merge boundary — sections with different h2 are never merged
      heading_hier — {level: text} snapshot at section start; used for
                     computing the common-ancestor prefix after a merge
      level        — heading level of this section's own heading (0 = intro)
    """
    lines = text.split("\n")
    heading_hier = {}   # {level: heading_text}, updated as we scan
    sections = []
    current_lines = []
    current_level = 0

    def flush():
        body = "\n".join(current_lines).strip()
        if not body:
            return
        hier_snapshot = dict(heading_hier)
        path_parts = [hier_snapshot[l] for l in sorted(hier_snapshot.keys()) if l > 1]
        if path_parts:
            path = " > ".join(path_parts)
            prefix = f"[Source: {page_display} | Section: {path}]\n\n"
        else:
            prefix = f"[Source: {page_display}]\n\n"
        sections.append({
            'prefix': prefix,
            'body': body,
            'h2': heading_hier.get(2),
            'heading_hier': hier_snapshot,
            'level': current_level,
        })

    for line in lines:
        lvl = heading_level(line)
        if lvl > 0:
            flush()
            current_lines = [line]
            current_level = lvl
            heading_text = strip_md_bold(re.match(r'^#{1,6}\s+(.*)', line).group(1))
            heading_hier[lvl] = heading_text
            for l in list(heading_hier.keys()):
                if l > lvl:
                    del heading_hier[l]
        else:
            current_lines.append(line)

    flush()
    return sections


def section_content(body):
    """Return body text with the first heading line stripped (the actual content)."""
    lines = body.split("\n")
    for i, line in enumerate(lines):
        if heading_level(line) > 0:
            return "\n".join(lines[i + 1:]).strip()
    return body.strip()


def common_ancestor_prefix(hier_a, hier_b, page_display):
    """
    Compute the context prefix for the common ancestor of two heading hierarchies.
    Walk levels in order; stop at the first level where the two differ or either
    is missing — everything above that is the common ancestor.
    """
    common = {}
    all_levels = sorted(set(hier_a.keys()) | set(hier_b.keys()))
    for level in all_levels:
        a_val = hier_a.get(level)
        b_val = hier_b.get(level)
        if a_val is not None and a_val == b_val:
            common[level] = a_val
        else:
            break
    path_parts = [common[l] for l in sorted(common.keys()) if l > 1]
    if path_parts:
        path = " > ".join(path_parts)
        return f"[Source: {page_display} | Section: {path}]\n\n"
    return f"[Source: {page_display}]\n\n"


def merge_sections(sections, page_display, min_content_chars):
    """
    Pass 2: Merge undersized sections forward.

    Rules:
    - Header-only section (no content below its heading line) → merge forward
    - Small section (content length < min_content_chars) → merge forward
    - Never merge across H2 boundaries (different h2 values)
    - After merge, recompute prefix as the common-ancestor heading
    - Repeat until stable (handles chains of small sections)
    """
    if not sections:
        return []

    merged = list(sections)
    changed = True

    while changed:
        changed = False
        result = []
        i = 0
        while i < len(merged):
            sec = merged[i]
            content = section_content(sec['body'])
            is_header_only = not content
            is_small = len(content) < min_content_chars

            if (is_header_only or is_small) and i + 1 < len(merged):
                nxt = merged[i + 1]
                # Block only when both sections are anchored to *different* H2s.
                # If either h2 is None (section is at H1 level or above), allow
                # the merge — e.g. a header-only H1 should fold into its child H2.
                same_boundary = (
                    sec['h2'] is None
                    or nxt['h2'] is None
                    or sec['h2'] == nxt['h2']
                )
                if same_boundary:
                    new_prefix = common_ancestor_prefix(
                        sec['heading_hier'], nxt['heading_hier'], page_display
                    )
                    new_body = sec['body'] + '\n\n' + nxt['body']
                    # Union of hierarchies; nxt wins on conflicts (it's the later state)
                    new_hier = {**sec['heading_hier'], **nxt['heading_hier']}
                    merged[i + 1] = {
                        'prefix': new_prefix,
                        'body': new_body,
                        'h2': nxt['h2'],
                        'heading_hier': new_hier,
                        'level': min(sec['level'], nxt['level']),
                    }
                    changed = True
                    i += 1  # skip sec; it has been absorbed into merged[i+1]
                    continue

            result.append(sec)
            i += 1

        merged = result

    return merged


def make_chunks(prefix, body, max_chars, overlap_chars):
    """
    Split a section into one or more chunks.
    If body fits within max_chars, returns a single chunk.
    Otherwise splits by paragraph with overlap_chars carried into the next chunk.
    """
    if len(prefix) + len(body) <= max_chars:
        return [prefix + body]

    avail = max_chars - len(prefix)
    paragraphs = [p for p in re.split(r'\n\n+', body) if p.strip()]
    if not paragraphs:
        return [prefix + body]

    chunks = []
    current = []
    current_len = 0

    for para in paragraphs:
        if current and current_len + len(para) + 2 > avail:
            chunks.append(prefix + "\n\n".join(current))
            overlap = []
            overlap_len = 0
            for p in reversed(current):
                if overlap_len + len(p) + 2 <= overlap_chars:
                    overlap.insert(0, p)
                    overlap_len += len(p) + 2
                else:
                    break
            current = overlap
            current_len = overlap_len
        current.append(para)
        current_len += len(para) + 2

    if current:
        chunks.append(prefix + "\n\n".join(current))

    return chunks


def process_wiki(wiki_dir, out_dir, max_chars, min_chars, overlap):
    total_chunks = 0
    for filename in sorted(os.listdir(wiki_dir)):
        if not filename.endswith(".md"):
            continue
        if filename == "_Sidebar.md":
            continue

        page_name = filename.replace(".md", "").lower().replace(" ", "-")
        page_display = filename.replace(".md", "").replace("-", " ").title()
        page_path = os.path.join(wiki_dir, filename)

        with open(page_path, "r", encoding="utf-8") as f:
            content = f.read()

        sections = build_sections(content, page_display)
        sections = merge_sections(sections, page_display, min_chars)

        all_chunks = []
        for sec in sections:
            all_chunks.extend(make_chunks(sec['prefix'], sec['body'], max_chars, overlap))

        if not all_chunks:
            continue

        page_dir = os.path.join(out_dir, page_name)
        os.makedirs(page_dir, exist_ok=True)

        for i, chunk in enumerate(all_chunks, start=1):
            out_path = os.path.join(page_dir, f"chunk-{i:03}.md")
            with open(out_path, "w", encoding="utf-8") as out:
                out.write(chunk)

        print(f"  {page_name}: {len(all_chunks)} chunks")
        total_chunks += len(all_chunks)

    print(f"Total: {total_chunks} chunks")


def main():
    parser = argparse.ArgumentParser(
        description="Chunk markdown wiki pages into Bedrock knowledge base files."
    )
    parser.add_argument("--wiki-dir", default="wiki", help="Source wiki directory")
    parser.add_argument("--out-dir", default="knowledge", help="Output knowledge directory")
    parser.add_argument("--max-chars", type=int, default=MAX_CHARS,
                        help="Max chars per chunk (prefix included)")
    parser.add_argument("--min-chars", type=int, default=MIN_CONTENT_CHARS,
                        help="Min content chars before a section is merged forward")
    parser.add_argument("--overlap", type=int, default=OVERLAP_CHARS,
                        help="Overlap chars carried into the next chunk on split")
    args = parser.parse_args()

    print(f"Chunking: {args.wiki_dir} → {args.out_dir} "
          f"(max={args.max_chars}, min={args.min_chars}, overlap={args.overlap})")
    process_wiki(args.wiki_dir, args.out_dir, args.max_chars, args.min_chars, args.overlap)


if __name__ == "__main__":
    main()
