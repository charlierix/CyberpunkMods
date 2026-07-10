# Loop 2: Concept Extraction

**Goal:** Read the source inventory and decide which items deserve to become OKF concepts. Produce a concept manifest. No OKF documents are written in this loop.

---

## Input

- `scan_inventory.md` from Loop 1

## Output

Write a single file to:
```
<bundle-dir>/.staging/concept_manifest.md
```

## File format

```markdown
# Concept Manifest

**Derived from:** scan_inventory.md
**Date:** <ISO 8601>
**Concept count:** <N>
**Total source items accounted for:** <N>
**Coverage target:** 100%

## Concepts

| # | Concept ID | Type | Title | Source ref(s) | Description | Member count | Priority |
|---|-----------|------|-------|--------------|-------------|-------------|----------|
| 1 | services/auth-api | API | Auth API | src/api/auth.py, src/api/auth_routes.py | Authentication and authorization service handling JWT tokens. | 3 | high |
| 2 | tables/users | Table | Users | db/schema/users.sql, src/models/user.py | User account table with profile and auth fields. | 2 | high |
| 3 | references/metrics/retention | Metric | Retention Rate | src/analytics/retention.py | 30-day rolling user retention calculation. | 1 | medium |

## Skipped files (and why)

| File | Reason skipped |
|------|---------------|
| .gitignore | Config metadata, not knowledge |
| node_modules/ | Dependencies, not project knowledge |

## Coverage verification

| Source item | Concept ID | Status |
|-----------|-----------|--------|
| src/api/auth.py | services/auth-api | covered |
| src/api/auth_routes.py | services/auth-api | covered |
| src/models/user.py | tables/users | covered |
```

## Instructions

1. Read `scan_inventory.md` completely.
2. For each file (or group of related files), decide:
   - **Is this a concept?** A concept is a *meaningful unit of knowledge* — something someone would look up to understand the project.
   - **What type?** Use descriptive type names (e.g. `Service`, `API`, `Table`, `Metric`, `Playbook`, `Reference`, `Config`, `Decision`, `Enum`, `Class`, `System`).
   - **What should the concept ID be?** This is the path within the bundle. Use kebab-case. Concept IDs may be arbitrarily deep — e.g. `services/auth/jwt`, `references/metrics/retention`, `systems/combat/weapons/ranged/smart-bullet`. Choose depth based on domain meaning, not source file paths.
   - **Which source files inform this concept?** List them.
   - **One-line description.**
   - **Member count:** How many source items belong to this concept?
   - **Priority**: `high` (core), `medium` (useful), `low` (nice-to-have).
3. **Group related files into single concepts.** Five files that implement one service = one concept, not five. But do NOT over-group — a concept with 500+ member types is too large and should be split into sub-concepts.
4. **Skip noise.** Dependencies, build artifacts, git metadata, and trivial config files are not concepts.
5. **Ensure full coverage.** Every meaningful source item must be assigned to exactly one concept. If a source item doesn't fit any concept, create one for it. The manifest must account for 100% of meaningful source items.
6. **Handle duplicates.** If the source has duplicate type names (e.g. `Cast` appears 127 times), list them explicitly in the concept's member count and note the duplication. Do not silently omit duplicates.
7. **Size guidance for concepts:**
   - **Too large:** A single concept with more than ~50-80 member types is hard to write meaningfully. Split it into sub-concepts (e.g. `ai/conditions`, `ai/actions`, `ai/commands` instead of one `ai-system`).
   - **Too small:** A concept with only 1 member type is fine if that type is meaningful on its own. Don't merge unrelated types just to inflate count.
   - **Right size:** 5-50 member types per concept is the sweet spot. Large enough to be meaningful, small enough to list every member.
8. Write the manifest to the output file, including the coverage verification table.

## What NOT to do

- Do NOT write any OKF `.md` concept documents.
- Do NOT decide the bundle directory structure (that's Loop 3).
- Do NOT read the actual source file contents — work from the inventory summaries.
- Do NOT create a concept for every single file — group related files.
- Do NOT over-group — a single concept covering 500+ types loses individual type identity.
- Do NOT leave source items unaccounted for — every meaningful item must appear in a concept.
- Do NOT silently drop duplicate type names — account for them explicitly.

## Stop condition

**Stop when `concept_manifest.md` is written and the coverage verification table accounts for every meaningful source item.** Do not proceed to structure planning.
