---
name: okf-build
description: >
  Parse a source folder structure and build a curated OKF knowledge bundle
  from it. Use when the user wants to create a new OKF bundle from an existing
  directory, codebase, docs, or data source. Triggers on: "build OKF from folder",
  "convert source to OKF", "generate OKF bundle", "create knowledge base from code".
triggers:
  - "build okf from"
  - "convert to okf"
  - "generate okf bundle"
  - "create okf from source"
---

# OKF Build — Create a Bundle from a Source Folder

This sub-skill of okf-create-maintain handles parsing a source directory and
building a conformant OKF bundle. Read the [parent skill](../SKILL.md) for
general conventions and the [spec](../../SPEC.md) for normative rules.

## Workflow

### 1. Inspect the source

Scan the source folder to understand its structure and content:

```bash
find <source-dir> -type f | head -80
```

Identify: What types of files exist? (code, docs, configs, schemas, CSVs)
What natural grouping emerges? (services, tables, APIs, metrics, playbooks)

### 2. Determine scope and directory layout

Ask the user (or infer from the source):
- What knowledge are we capturing?
- What concept types will we use?
- What directory structure makes sense for the domain?

Common layouts — nesting depth is unlimited, organize by domain meaning:

```
.okf/
├── index.md
├── log.md
├── services/
│   ├── index.md
│   ├── auth/
│   │   ├── index.md
│   │   ├── jwt.md
│   │   └── permissions.md
│   └── payment/
│       ├── index.md
│       └── processing.md
├── tables/
│   ├── index.md
│   └── <table>.md
├── references/
│   ├── index.md
│   ├── metrics/
│   │   ├── index.md
│   │   └── <metric>.md
│   └── enums/
│       ├── index.md
│       └── <enum>.md
└── playbooks/
    ├── index.md
    └── <playbook>.md
```

Every directory that contains concepts or subdirectories with concepts gets its own `index.md` for progressive disclosure.

### 3. Create concept documents

One concept per `.md` file. Use the [concept template](../templates/concept.md).

Minimal conformant concept:

```markdown
---
type: <Type>
title: <Display Name>
description: <One sentence summary>
tags: [tag1, tag2]
timestamp: 2026-06-28T00:00:00Z
---

# Overview

<Body content>
```

**Key rules:**
- `type` is **required** and must be non-empty.
- `title`, `description`, `tags`, `timestamp` are recommended.
- `resource` is for concepts bound to a real asset — omit for abstract concepts.
- Body should favor structural markdown (headings, tables, lists, code blocks).
- Use `# Schema` for data assets, `# Examples` for usage, `# Citations` for sources.

### 4. Cross-link concepts

Use standard markdown links. Two forms:

- **Absolute** (bundle-relative, starts with `/`): `[customers](/tables/customers.md)` — **preferred**
- **Relative**: `[churn](./churn.md)`

Links assert relationships. The kind of relationship is conveyed by surrounding
prose. Broken links are explicitly permitted — they represent not-yet-written
knowledge.

### 5. Generate index.md files

Place in every directory for progressive disclosure. No frontmatter (except
bundle-root may carry `okf_version: "0.1"`). Use the [index template](../templates/index.md).

```markdown
# Services

* [Auth API](./auth-api.md) - Authentication and authorization service
* [Payment API](./payment-api.md) - Payment processing service
```

Entries should include the description from the linked concept's frontmatter.

### 6. Generate log.md (optional but recommended)

Chronological change history, newest first, ISO 8601 date headings. Use the
[log template](../templates/log.md).

### 7. Declare version (optional)

Bundle-root `index.md` may include frontmatter declaring the spec version:

```markdown
---
okf_version: "0.1"
---

# My Knowledge Bundle

- [Services](./services/) - Service definitions
- [Tables](./tables/) - Database tables
```

### 8. Validate

Before declaring done, load and follow the [validate sub-skill](../validate/SKILL.md).
Fix every ERROR before finishing. Warnings are soft — fix when cheap.

## Source-specific conversion tips

| Source type | Strategy |
|-------------|----------|
| **Code** | Derive concepts from source files, READMEs, docstrings, config. One concept per service/module/API. |
| **Docs/Wiki** | Distill pages into concepts. Link originals under `# Citations`. |
| **CSV/Spreadsheet** | Each row = one concept. Map columns to frontmatter fields. First column = filename. |
| **Notion export** | Properties → frontmatter. Remove UUID suffixes from filenames. Convert Notion links → relative markdown links. |
| **Obsidian vault** | Convert `[[wikilinks]]` → `[title](./file.md)`. Ensure `type` field exists. Move inline `#tags` to frontmatter. |
| **Manual** | Decisions, playbooks, metrics — author directly from template. |

## Output format

When creating a bundle, present results as:

1. **Directory tree** showing the full structure
2. **Each file's content** in fenced code blocks
3. **Conformance check** confirming the bundle passes validation

```
my-bundle/
├── index.md
├── log.md
├── services/
│   ├── index.md
│   └── auth-api.md
└── tables/
    ├── index.md
    └── orders.md
```

Then show each file, then confirm: "Bundle is OKF v0.1 conformant ✅"
