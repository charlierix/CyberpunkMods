# OKF Bundle Query Playbook

**Version 0.3**

This playbook guides searching and querying an existing OKF knowledge bundle to find concepts, metadata, relationships, and answers.

---

## How to Use

You are an agent that has been told:

> Query `<bundle-dir>` according to the instructions in `<bundle-dir>/.agent`

This `.agent` folder contains this playbook (`query playbook.md`), a `build playbook.md`, a `loops/` subfolder, and a `skills/` subfolder with OKF skills and scripts.

### Execution model

1. Read this playbook to understand the query strategy.
2. Identify what the user is asking about.
3. Pick the appropriate search method below.
4. Execute the search using shell commands or the bundled script.
5. Read relevant concept files for detail.
6. Report findings.

---

## Progressive Disclosure Strategy

OKF is designed for progressive disclosure — start broad, then drill in:

1. **Read the root `index.md`** first to see what the bundle contains.
2. **Follow links** into subdirectories or specific concepts relevant to the query.
3. **Read concept bodies** for detailed information.

```bash
cat <bundle-dir>/index.md
```

---

## Search Methods

### Method 1: Browse via index files

```bash
cat <bundle-dir>/index.md
cat <bundle-dir>/services/index.md
```

Follow the links in the index to navigate to relevant concepts.

### Method 2: Search by frontmatter field

Use grep to find concepts by `type`, `tags`, `title`, or any frontmatter field:

```bash
# Find all concepts of a specific type
grep -rl "^type: Table" <bundle-dir> --include="*.md"

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

For complex queries across frontmatter fields, use the bundled script:

```bash
python3 "<bundle-dir>/.agent/skills/search/scripts/okf_search.py" <bundle-dir> --type "Table" --tag "revenue"
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

### Method 6: Interactive visualization

If the bundle has been visualized (Loop 7 of the build playbook), open `viz.html`:

```bash
ls <bundle-dir>/viz.html
```

Open it in a browser to explore the concept graph interactively — filter by type, search by text, click nodes for detail panels with backlinks.

---

## Query Patterns

| Question | Approach |
|----------|----------|
| What's in this bundle? | Read root `index.md` |
| What types exist? | `python3 okf_search.py <dir> --list-types` |
| What tags exist? | `python3 okf_search.py <dir> --list-tags` |
| Find all tables | `grep -rl "^type:.*Table" <dir> --include="*.md"` |
| Find by tag | `grep -rl "tag_name" <dir> --include="*.md"` |
| What links to X? | `grep -rl "X.md" <dir> --include="*.md"` |
| Full-text search | `grep -rn "keyword" <dir> --include="*.md"` |
| Structured query | `python3 okf_search.py <dir> --type ... --tag ...` |
| Visual exploration | Open `<bundle-dir>/viz.html` in a browser |

---

## Guidelines

- **Start with `index.md`** — progressive disclosure is the intended entry point.
- **Treat broken links as not-yet-written knowledge** — not errors (spec section 5.3).
- **Preserve unknown fields** — if you learn something while searching, write it back via the maintain mode of okf-create-maintain.
- **Use `--json`** for programmatic consumption or when feeding results to downstream tools.

---

## Relationship to Skills

| Skill | Used for |
|-------|----------|
| `okf-search` | All query methods above |
| `okf-visualization` | Interactive graph exploration |
| `okf-create-maintain` | Writing back findings (maintain mode) |
