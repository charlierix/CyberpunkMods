# Loop 1: Pre-scan

**Goal:** Produce a raw, factual inventory of the source directory. No analysis, no judgment, no concepts. Just facts.

---

## Input

- Source directory path (e.g. `/path/to/source`)

## Output

Write a single file to:
```
<bundle-dir>/.staging/scan_inventory.md
```

## File format

```markdown
# Source Inventory

**Source path:** `<source-dir>`
**Scan date:** <ISO 8601>
**Total files:** <N>
**Total dirs:** <N>
**Source type:** <code | data | docs | mixed | other>

## File listing

| # | Path | Type | Size | Lines | One-line summary |
|---|------|------|------|-------|-----------------|
| 1 | src/main.py | code | 4.2KB | 120 | Main entry point, FastAPI app |
| 2 | README.md | doc | 2.1KB | 55 | Project README with setup instructions |

## Directory tree

<source-dir>/
├── ...
```

## Script assistance (optional)

The `scan_inventory.py` script can automate this loop by walking the source directory, collecting file metadata (type, size, line count, one-line summary), and writing `scan_inventory.md`. It works on **any source type** — code, docs, data, prose. See `scripts/index.md` for usage.

## Instructions

1. Run `find <source-dir> -type f` to list all files.
2. Determine the **source type** — is this code, structured data (JSON/CSV), documentation, or mixed? Record this in the inventory header.
3. For each file, determine:
   - **Path** (relative to source root)
   - **Type**: one of `code`, `doc`, `config`, `data`, `test`, `schema`, `other`
   - **Size**: human-readable (e.g. `4.2KB`)
   - **Lines**: line count (use `wc -l`)
   - **One-line summary**: read the first few lines / frontmatter / function names and write a SINGLE factual sentence. No interpretation.
4. For structured data sources (JSON, CSV, etc.):
   - Note the schema structure (keys, fields, or columns) in the summary
   - If the source has an index file (e.g. `index.json`), record the number of entries it contains — this count is critical for coverage verification in later loops
   - If files are named by index number (e.g. `1838.json`), note this pattern
5. Run `find <source-dir> -type d` for the directory tree.
6. Write the complete inventory to the output file.

## What NOT to do

- Do NOT propose concepts.
- Do NOT decide what's important vs unimportant.
- Do NOT group or categorize beyond the file type.
- Do NOT read entire files — just enough for a one-line summary.
- Do NOT start writing OKF documents.
- Do NOT skip the source-type classification — it guides all downstream loops.

## Stop condition

**Stop when `scan_inventory.md` is written and contains every file in the source directory, plus the source-type classification.** Do not proceed to concept extraction.
