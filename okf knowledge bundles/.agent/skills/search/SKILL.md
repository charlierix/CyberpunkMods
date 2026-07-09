---
name: okf-search
description: >
  Search and query an Open Knowledge Format (OKF) bundle to find concepts,
  metadata, or relationships. Use when the user asks to search, query, find,
  lookup, or explore knowledge within an existing OKF bundle. Triggers on:
  "search OKF", "query OKF bundle", "find concept", "lookup in OKF",
  "search knowledge bundle", "what does the OKF say about".
triggers:
  - "search okf"
  - "query okf"
  - "find concept"
  - "lookup okf"
  - "search knowledge bundle"
  - "okf query"
---

# OKF Search — Query an OKF Bundle

This skill guides searching and querying an existing OKF knowledge bundle to
find concepts, metadata, relationships, and answers. Read the [spec](../SPEC.md)
for normative rules on bundle structure.

## Progressive disclosure strategy

OKF is designed for progressive disclosure — start broad, then drill in:

1. **Read the root `index.md`** first to see what the bundle contains.
2. **Follow links** into subdirectories or specific concepts relevant to the
   query.
3. **Read concept bodies** for detailed information.

## Search methods

### Method 1: Browse via index files

```bash
cat <bundle-dir>/index.md
```

Follow the links in the index to navigate to relevant concepts.

### Method 2: Search by frontmatter field

Use grep to find concepts by `type`, `tags`, `title`, or any frontmatter field:

```bash
# Find all concepts of a specific type
grep -rl "^type: BigQuery Table" <bundle-dir> --include="*.md"

# Find concepts with a specific tag
grep -rl "revenue" <bundle-dir> --include="*.md"

# Find by title
grep -rl "^title: .*orders" <bundle-dir> --include="*.md" -i
```

### Method 3: Full-text search across concept bodies

```bash
# Search for a keyword in all concept files
grep -rn "keyword" <bundle-dir> --include="*.md"

# Search excluding reserved files
grep -rn --include="*.md" --exclude="index.md" --exclude="log.md" "keyword" <bundle-dir>
```

### Method 4: Structured frontmatter query (Python)

For more complex queries across frontmatter fields, use the bundled script:

```bash
python3 scripts/okf_search.py <bundle-dir> --type "BigQuery Table" --tag "revenue"
```

Available filters:

| Flag | Description |
|------|-------------|
| `--type <value>` | Filter by concept type (case-insensitive substring match) |
| `--tag <value>` | Filter by tag (exact match against YAML list) |
| `--title <value>` | Filter by title (case-insensitive substring match) |
| `--desc <value>` | Filter by description (case-insensitive substring match) |
| `--text <value>` | Full-text search across body (case-insensitive) |
| `--json` | Output results as JSON |
| `--list-types` | List all unique types and counts |
| `--list-tags` | List all unique tags and counts |

### Method 5: Graph traversal (follow links)

To understand relationships, trace cross-links between concepts:

```bash
# Find all outgoing links from a concept
grep -oP '\[([^\]]*)\]\(([^)]+)\.md\)' <bundle-dir>/services/auth-api.md

# Find all concepts that link to a specific concept
grep -rl "auth-api.md" <bundle-dir> --include="*.md"
```

## Query patterns

| Question | Approach |
|----------|----------|
| What's in this bundle? | Read root `index.md` |
| What types exist? | `python3 scripts/okf_search.py <dir> --list-types` |
| What tags exist? | `python3 scripts/okf_search.py <dir> --list-tags` |
| Find all tables | `grep -rl "^type:.*Table" <dir> --include="*.md"` |
| Find by tag | `grep -rl "tag_name" <dir> --include="*.md"` |
| What links to X? | `grep -rl "X.md" <dir> --include="*.md"` |
| Full-text search | `grep -rn "keyword" <dir> --include="*.md"` |
| Structured query | `python3 scripts/okf_search.py <dir> --type ... --tag ...` |

## Guidelines

- **Start with `index.md`** — progressive disclosure is the intended entry point.
- **Treat broken links as not-yet-written knowledge** — not errors (§5.3).
- **Preserve unknown fields** — if you learn something while searching, write
  it back via the maintain mode of okf-create-maintain.
- **Use `--json`** for programmatic consumption or when feeding results to
  downstream tools.
