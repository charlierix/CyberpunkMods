# Build Scripts

Reusable Python scripts for automating OKF bundle build loops. Each script corresponds to a specific loop in the [Build Playbook](../build%20playbook.md).

## Scripts

| Script | Loop | Purpose | Source types |
|--------|------|---------|---------------|
| [scan_inventory.py](./scan_inventory.py) | Loop 1 — Pre-scan | Walks source directory, collects file metadata, writes `scan_inventory.md` | **Any** — works on all source types |
| [generate_concepts/swift_parser.py](./generate_concepts/swift_parser.py) | Loop 4 — Generation | Reads manifest + plan, extracts source declarations, writes concept `.md` files | **Code only (Swift)** — uses regex to extract class/struct/enum/function declarations. For other languages or non-code sources, generate concepts manually or add a new parser to the `generate_concepts/` folder. |
| [generate_indexes.py](./generate_indexes.py) | Loop 5 — Index & link | Generates `index.md` files at **every directory level** (arbitrary nesting), verifies cross-links, writes `log.md` | **Any** — operates on the generated bundle, not the source |
| [fix_yaml_resources.py](./fix_yaml_resources.py) | Loop 6 — Validate (fix) | Fixes unquoted YAML frontmatter values that break parsing (e.g. `resource: !path` → `resource: "!path"`) | **Any** — operates on the generated bundle, not the source |

## Adding new source-type parsers

The `generate_concepts/` folder holds one parser per source language or content type. To add support for a new language:

1. Create a new script in `generate_concepts/` (e.g. `python_parser.py`, `reds_parser.py`).
2. Follow the same interface as `swift_parser.py`: reads manifest + plan, reads source files, extracts declarations, writes concept `.md` files.
3. Add an entry to the table above with the appropriate **Source types** column.
4. Mention it in the relevant loop file (`loops/loop-4-generation.md`).

## Usage

### Loop 1: Scan a source directory

```bash
python3 scan_inventory.py <source-dir> <bundle-dir>
```

Walks every file in `<source-dir>`, classifies by type (code, doc, config, data, test, schema, other), extracts size, line count, and a one-line summary from the first ~10 lines. Writes the full inventory to `<bundle-dir>/.staging/scan_inventory.md`.

**Output:** `scan_inventory.md` with a file listing table and directory tree.

---

### Loop 4: Generate concept documents (Swift)

```bash
python3 generate_concepts/swift_parser.py <source-dir> <bundle-dir> [--manifest <path>] [--plan <path>]
```

Reads the concept manifest and bundle plan (from `.staging/` by default), then for each concept:

1. Reads the referenced source files from `<source-dir>`
2. Extracts class, struct, enum, protocol, and function names via regex
3. Generates an OKF-formatted markdown file with YAML frontmatter (`type`, `title`, `description`, `resource`, `tags`, `timestamp`) and structured body sections (Overview, Key Source Files, Architecture, Notable Types, Dependencies, Citations)

Writes one `.md` file per concept to `<bundle-dir>/<dir>/<concept>.md`.

**Requirements:** Manifest and plan must follow the table format from Loops 2 and 3.

---

### Loop 5: Generate indexes and log

```bash
python3 generate_indexes.py <bundle-dir> [--source-dir <path>] [--name <title>]
```

Scans the bundle for all concept `.md` files, parses their frontmatter, and generates:

- **Root `index.md`** — Lists all top-level directories with concept counts and descriptions, includes `okf_version: "0.1"` frontmatter
- **Subdirectory `index.md`** — One per directory, listing all concepts with title + description links
- **`log.md`** — Dated change log entry describing the generation

Also verifies cross-links between concept documents and reports any broken links.

---

### Loop 6 fix: Fix YAML frontmatter quoting

```bash
python3 fix_yaml_resources.py <bundle-dir> [--dry-run]
```

Fixes a common YAML parsing error where `resource:` or other frontmatter fields start with a YAML special character (`!`, `&`, `*`, `@`, `%`, `#`, `>`, `|`, `{`, `[`, `` ` ``, `~`). These characters cause YAML parsers to fail. The script wraps such values in double quotes.

Use `--dry-run` to preview which files would be changed without writing.

---

## Typical Build Workflow

```bash
# Loop 1: Scan source
python3 scripts/scan_inventory.py ../!source ../bundle

# Loops 2-3: Concept extraction and structure planning
# (Manual or agent-driven — produce concept_manifest.md and bundle_plan.md in .staging/)

# Loop 4: Generate concept documents (Swift)
python3 scripts/generate_concepts/swift_parser.py ../!source ../bundle

# Loop 5: Generate indexes, verify links, write log
python3 scripts/generate_indexes.py ../bundle --source-dir ../!source --name "My Bundle"

# Loop 6: Validate
python3 ../bundle/.agent/skills/create-maintain/validate/scripts/okf_validate.py ../bundle --json

# Loop 6 fix (if resource: errors appear)
python3 scripts/fix_yaml_resources.py ../bundle

# Loop 7: Visualize
python3 ../bundle/.agent/skills/visualization/scripts/okf_visualize.py ../bundle
```

## Notes

- Loops 2 (concept extraction) and 3 (structure planning) are **not automated** by scripts here because they require judgment-based grouping and curation that varies per project. Use an AI agent or manual analysis for those loops.
- All scripts use only the Python standard library — no external dependencies required.
- Scripts exclude `.staging/`, `index.md`, and `log.md` from concept file scans.
- The `generate_concepts/` folder is extensible — add a new parser script for each new source language or content type encountered.
