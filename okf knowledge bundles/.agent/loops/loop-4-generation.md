# Loop 4: Generation (Per Concept)

**Goal:** Write OKF concept documents, **one at a time**. Each iteration of this loop produces exactly one `.md` file.

This loop is **repeated** — run it once per concept in the manifest.

---

## Input

- `bundle_plan.md` from Loop 3 (for path and type info)
- `concept_manifest.md` from Loop 2 (for source refs, description, and member count)
- The **specific concept** to generate this iteration
- Access to the source files referenced by this concept

## Output

One `.md` file written to the concept's bundle path:
```
<bundle-dir>/<concept-path>.md
```

## File format

Follow the OKF spec (section 4). Every concept file must have:

1. **YAML frontmatter** (delimited by `---`):
   - `type` (REQUIRED, non-empty)
   - `title` (recommended)
   - `description` (recommended — one sentence)
   - `resource` (if the concept is bound to a real asset)
   - `tags` (recommended — YAML list)
   - `timestamp` (recommended — ISO 8601)

2. **Markdown body** with structural content:
   - Short prose overview (1-3 paragraphs)
   - **Complete member listing** — ALL member types/items assigned to this concept must be explicitly named
   - `# Schema` — for data assets (tables, datasets)
   - `# Examples` — concrete usage examples
   - `# Citations` — external sources
   - Other headings as appropriate (`# Endpoints`, `# Configuration`, `# Dependencies`, etc.)

## Critical rule: Complete coverage

Every source item assigned to this concept in the manifest MUST appear in the concept file. Do not sample, abbreviate, or list only "key" types. If the manifest says this concept has 50 member types, all 50 must appear in the document.

**Strategies for large member lists:**
- Use tables for structured data (Type, Bases, Methods/Fields/Values)
- Group members under sub-headings by sub-category if there are natural divisions
- Use collapsed/summary sections if the list is very long (50+ members)
- If a concept has too many members to list meaningfully (100+), this is a signal that Loop 2 should have split it into sub-concepts

## Example

```markdown
---
type: API
title: Auth API
description: Authentication and authorization service handling JWT tokens.
resource: https://github.com/myorg/myproject/tree/main/src/api/auth
tags: [auth, jwt, security]
timestamp: 2026-06-28T00:00:00Z
---

# Overview

The Auth API provides JWT-based authentication and RBAC authorization
for all platform services. It exposes endpoints for login, token refresh,
and permission checking.

# Member Types

| Type | Bases | Key Methods |
|------|-------|------------|
| AuthManager | IScriptable | Login, RefreshToken, CheckPermission |
| JWTToken | IScriptable | Generate, Validate, Decode |
| PermissionSet | IScriptable | Has, Add, Remove |
| AuthConfig | IScriptable | GetTTL, GetSecret |
| AuthEvent | IScriptable | GetType, GetUser |
| AuthResult | IScriptable | IsSuccess, GetToken, GetError |

# Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | /auth/login | Authenticate and receive JWT |
| POST | /auth/refresh | Refresh expired token |
| GET | /auth/permissions | Check user permissions |

# Citations

[1] [Auth API source](https://github.com/myorg/myproject/tree/main/src/api/auth)
```

## Script assistance (optional)

The `generate_concepts/swift_parser.py` script can automate this loop for **Swift** source code by reading source files and extracting class/struct/enum/function declarations via regex. It produces poor or empty results for **non-code sources** (documentation, data files, spreadsheets, prose) or other programming languages. For non-Swift sources, generate concepts manually by reading and summarizing the source files as instructed below, or add a new parser to the `generate_concepts/` folder (see `scripts/index.md`).

## Instructions (per iteration)

1. From the manifest, identify the **source ref(s)** for this concept and the **member count**.
2. Read the referenced source file(s). Read the actual code/docs/data — not just the inventory summary.
3. **Identify ALL member types** that belong to this concept. Cross-reference against the manifest to ensure none are missed.
4. Compose the frontmatter:
   - Set `type` from the manifest.
   - Write `title` and `description` (one sentence).
   - Add `resource` if there's a canonical URL/path.
   - Add `tags` inferred from the content.
   - Set `timestamp` to the current date.
5. Compose the body:
   - Write a short overview.
   - **List every member type** in a structured table or grouped sections. Do NOT sample — list all members.
   - For each member, include available metadata (bases, key methods, fields, enum values, etc.).
   - If a member has no meaningful metadata beyond its name, still list it — a name alone is better than omission.
   - Add structured sections appropriate to the concept type.
   - Include any cross-links from the bundle plan, using absolute bundle-relative paths (e.g. `/tables/users.md`).
   - Add `# Citations` with links to source files.
6. **Verify coverage:** Count the member types listed in the file. Compare against the manifest's member count. If they don't match, find what's missing and add it.
7. Write the file to the concept's bundle path.
8. **Stop.** Do not start the next concept.

## Concept-type body patterns

| Type | Suggested body sections |
|------|------------------------|
| `Service` / `API` | `# Overview`, `# Member Types` (table), `# Endpoints`, `# Configuration`, `# Dependencies` |
| `Table` / `Dataset` | `# Overview`, `# Schema`, `# Common query patterns`, `# Citations` |
| `Metric` | `# Overview`, `# Formula`, `# Examples`, `# Citations` |
| `Playbook` | `# Overview`, `# Steps`, `# Prerequisites`, `# Troubleshooting` |
| `Reference` / `Enum` | `# Overview`, `# Values` (complete listing), `# Notes`, `# Citations` |
| `System` | `# Overview`, `# Member Types` (complete table), `# Notable Methods`, `# Dependencies` |
| `Decision` | `# Context`, `# Decision`, `# Rationale`, `# Alternatives` |

## What NOT to do

- Do NOT write multiple concepts in one iteration.
- Do NOT write `index.md` or `log.md` (that's Loop 5).
- Do NOT invent data. If the source doesn't mention something, don't add it.
- Do NOT read source files for other concepts — only the ones for this concept.
- Do NOT sample or abbreviate member types — list every single one.
- Do NOT skip a member because it seems trivial — if it's in the manifest, it goes in the file.
- Do NOT silently drop duplicate type names — list them and note the duplication.

## Stop condition (per iteration)

**Stop when the single concept file is written AND the member count in the file matches the manifest.** The orchestrator (human or agent) should then invoke the next iteration for the next concept.

## Stop condition (entire loop)

**The generation loop is complete when every concept in the manifest has a written `.md` file.** Do not proceed to index & link until all concepts exist.
