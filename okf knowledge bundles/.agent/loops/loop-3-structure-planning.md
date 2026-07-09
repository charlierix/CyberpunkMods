# Loop 3: Structure Planning

**Goal:** Take the concept manifest and design the OKF bundle's directory structure. Produce a bundle plan. No OKF documents are written in this loop.

---

## Input

- `concept_manifest.md` from Loop 2

## Output

Write a single file to:
```
<bundle-dir>/.staging/bundle_plan.md
```

## File format

```markdown
# Bundle Plan

**Derived from:** concept_manifest.md
**Date:** <ISO 8601>

## Directory tree

Nest as deep as the domain requires. Every directory that contains concepts or subdirectories with concepts gets its own `index.md`.

```
<bundle-root>/
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
│       ├── processing.md
│       └── refunds.md
├── tables/
│   ├── index.md
│   ├── users.md
│   └── orders.md
├── references/
│   ├── index.md
│   ├── metrics/
│   │   ├── index.md
│   │   ├── retention.md
│   │   └── churn.md
│   └── enums/
│       ├── index.md
│       └── status-codes.md
└── playbooks/
    ├── index.md
    └── deployment.md
```

## Concept -> path mapping

| Concept ID | Bundle path | Type | Title | Member count |
|-----------|-------------|------|-------|-------------|
| services/auth/jwt | services/auth/jwt.md | Service | JWT Token Service | 8 |
| services/auth/permissions | services/auth/permissions.md | Service | Permissions Service | 5 |
| references/metrics/retention | references/metrics/retention.md | Metric | Retention Rate | 1 |

## Index specs

| Index file | Will list |
|-----------|----------|
| index.md (root) | All top-level directories with descriptions |
| services/index.md | Subdirectories (auth/, payment/) with descriptions |
| services/auth/index.md | Concepts in services/auth/ (jwt, permissions) |
| tables/index.md | Concepts in tables/ (users, orders) |

## Cross-link plan

| From | To | Context |
|------|-----|---------|
| services/auth-api.md | tables/users.md | "validates against the [users table](/tables/users.md)" |
```

## Instructions

1. Read `concept_manifest.md` completely.
2. Group concepts by type into top-level directories (e.g. `services/`, `tables/`, `metrics/`, `playbooks/`, `references/`).
3. **Decide nesting depth.** There is no hard cap — nest as deep as the domain requires:
   - If a directory would have more than ~15-20 concepts, split into subdirectories by sub-type or sub-domain.
   - If a concept naturally belongs inside a sub-grouping (e.g. `services/auth/jwt.md` rather than `services/jwt.md`), create the subdirectory.
   - If the source has deep organizational structure that maps to meaningful knowledge boundaries, mirror that depth in the bundle.
   - **HARD RULE: Flatten single-child leaf folders.** If a subdirectory would contain only one concept `.md` file (and no other subdirectories), do NOT create the subdirectory — place the concept file directly in its parent. For example, `effects/continuous-effector/continuous-effector-782.md` is wrong; use `effects/continuous-effector-782.md` instead. Single-item subdirectories add a nesting level with zero organizational value and create unnecessary `index.md` overhead.
4. Assign each concept a final path in the bundle. Paths may be arbitrarily deep (e.g. `systems/combat/weapons/ranged/smart-bullet.md`).
5. Plan which `index.md` files are needed — **every directory that contains concepts or subdirectories with concepts gets an `index.md`**, at every level of nesting.
6. Plan cross-links: which concepts reference each other, and the link text.
7. Write the bundle plan to the output file.

## Directory naming conventions

- Use **plural nouns** for directories: `services/`, `tables/`, `metrics/`, `references/`.
- Use **kebab-case** for concept filenames: `auth-api.md`, not `authApi.md` or `auth_api.md`.
- Nest **as deep as the domain requires** — no hard cap on depth. Use nesting when it adds organizational clarity; flatten when it doesn't.
- Common top-level directories:

  | Directory | For concepts about... |
  |-----------|----------------------|
  | `services/` | Services, microservices, daemons |
  | `apis/` or `endpoints/` | API endpoints or API groups |
  | `tables/` | Database tables, datasets |
  | `metrics/` | Business metrics, KPIs |
  | `playbooks/` | Operational procedures, runbooks |
  | `references/` | Enums, glossaries, conventions |
  | `decisions/` | Architecture decisions, ADRs |
  | `components/` | UI components, shared libraries |
  | `systems/` | Engine subsystems, game systems |
  | `entities/` | Game entities, NPCs, vehicles |
  | `devices/` | Interactive devices, controllers |
  | `player/` | Player-specific systems |
  | `ai/` | AI behaviors, conditions, actions |

## What NOT to do

- Do NOT write any OKF `.md` concept documents.
- Do NOT create directories or files on disk yet.
- Do NOT mechanically mirror the source directory structure — curate concepts and organize by domain meaning, not by source file paths.
- Do NOT create nesting levels with only one child — flatten single-child paths. This is a **hard rule**, not guidance. A subdirectory containing exactly one concept `.md` file and no other subdirectories MUST NOT exist — place that file in the parent directory instead.

## Stop condition

**Stop when `bundle_plan.md` is written.** Do not proceed to generation.
