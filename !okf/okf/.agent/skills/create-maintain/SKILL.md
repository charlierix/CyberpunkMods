---
name: okf-create-maintain
description: >
  Create, maintain, and update Open Knowledge Format (OKF) knowledge bundles —
  portable markdown + YAML frontmatter that both humans and agents read. Use when
  capturing project knowledge (services, APIs, schemas, metrics, runbooks,
  decisions) into an OKF bundle, when updating one after code or docs change, or
  when a repository contains an OKF bundle that should inform the task. Triggers
  on: "create OKF bundle", "build OKF", "maintain OKF", "update knowledge bundle",
  "capture this as a concept", "convert to OKF", or any work in a repo that has an
  OKF bundle.
triggers:
  - "create okf"
  - "build okf"
  - "maintain okf"
  - "update okf"
  - "okf bundle"
  - "knowledge bundle"
  - "convert to okf"
  - "capture as concept"
---

# OKF Create & Maintain

OKF represents knowledge as a directory of markdown files with YAML frontmatter.
It is minimal by design: no schema registry, no runtime, no SDK. Your job is to
produce, maintain, and consume OKF bundles **conformant with the spec**, not your
memory of it.

**Always read the canonical spec before non-trivial work:**
[../SPEC.md](../SPEC.md). It is the verbatim OKF v0.1 specification and the
source of truth for every rule below.

## The one hard rule

A bundle is conformant (§9) iff: every non-reserved `.md` file has a parseable
YAML frontmatter block, and every such block has a **non-empty `type`** field.
Everything else is soft guidance. Consumers MUST tolerate missing optional
fields, unknown types, and broken links — never reject a bundle over them.

## Sub-skills

| Sub-skill | When to use | Path |
|-----------|-------------|------|
| **build** | Parse a source folder structure and build a new OKF bundle from scratch, or extend an existing one with new concepts. | [build/SKILL.md](build/SKILL.md) |
| **validate** | Check that an OKF bundle is conformant with the v0.1 spec (§9). Run before committing changes or declaring done. | [validate/SKILL.md](validate/SKILL.md) |

## Conventions to apply (all modes)

- **One concept = one file.** The file path (minus `.md`) is the concept ID.
- **Frontmatter:** `type` is required. Add `title`, `description`, `tags`,
  `timestamp` (ISO 8601) when they aid consumption; add `resource` (a canonical
  URI) only for concepts bound to a real asset — omit it for abstract concepts.
- **Body:** prefer structural markdown (headings, tables, lists, fenced code).
  Conventional headings: `# Schema`, `# Examples`, `# Citations`.
- **Cross-links:** standard markdown links; prefer absolute bundle-relative
  form (`/services/auth-api.md`). A link asserts a relationship; its *kind* lives
  in the surrounding prose, not the link.
- **Reserved files:** `index.md` (directory listing, no frontmatter — except the
  bundle-root index may carry only `okf_version`) and `log.md` (ISO-dated change
  history, newest first). Never use these names for concepts.

Templates: [templates/concept.md](templates/concept.md),
[templates/index.md](templates/index.md), [templates/log.md](templates/log.md).

## Default bundle location

Use `.okf/` at the repository root unless the project already uses another
location. Commit it alongside the code it describes — knowledge as code.

## Modes

### produce — create or extend a bundle

Load and follow the [build sub-skill](build/SKILL.md).

### maintain — keep a bundle in sync with reality

1. Identify which concepts the change affects (search by `resource`, path, or
   topic). Touch every affected file in one pass.
2. Update the body and `timestamp`; fix or add cross-links; create new concepts
   for new assets; mark removed assets (`**Deprecation**`) rather than silently
   deleting context.
3. Update the relevant `index.md` files and append a dated `log.md` entry
   describing what changed.
4. Validate — load and follow the [validate sub-skill](validate/SKILL.md).

### consume — use a bundle as context

1. Read the bundle-root `index.md` first for progressive disclosure, then follow
   links only into the concepts relevant to the task.
2. Treat broken links as not-yet-written knowledge, not errors.
3. If you learn something durable while working, switch to **maintain** and
   write it back.

## Guardrails

1. **NEVER invent data.** If you don't know the correct `type`, ask. If you
   don't have schema info, leave it out. No fabricated URLs or column names.
2. **Preserve unknown fields.** OKF explicitly allows extension. Don't delete
   fields you don't recognize.
3. **Don't impose taxonomy.** Type values are free-form strings. Suggest
   descriptive values but never reject a bundle for having unexpected types.
4. **Broken links are OK.** The spec explicitly permits them — they represent
   not-yet-written knowledge.
5. **Minimal by default.** Generate only `type` (required) + recommended fields
   that are warranted. Don't pad with empty values.
6. **Ask before assuming.** If the domain is unclear, ask what types and
   structure make sense.
