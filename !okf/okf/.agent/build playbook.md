# OKF Bundle Build Playbook

**Version 0.4**

This playbook orchestrates the generation of an OKF knowledge bundle from a source directory. It uses a loop-based strategy where each loop has a single input, a single output artifact, and a clear stop condition.

Run each loop in order. Do not start the next loop until the current one's output file exists and looks correct.

---

## How to Use

You are an agent that has been told:

> Populate `<bundle-dir>` from `<source-dir>` according to the instructions in `<bundle-dir>/.agent`

This `.agent` folder contains this playbook (`build playbook.md`), a `query playbook.md`, a `loops/` subfolder with one instruction file per loop, and a `skills/` subfolder with OKF skills and scripts.

### Execution model

1. Read this playbook to understand the full pipeline.
2. For each loop, read its instruction file in `loops/`.
3. Execute the loop — follow its instructions literally.
4. When the loop's stop condition is met, pause and verify the output artifact exists.
5. Proceed to the next loop.
6. Repeat through loop 7.

### One loop at a time

Each loop is self-contained. Feed the model one loop's instructions plus its required input. Do not load all loops at once. The output artifact from each loop is the input to the next.

---

## Core Principle: Curate, Don't Mirror — But Don't Discard Either

An OKF bundle is a curated knowledge corpus, not a mirror of the source tree. However, curation means **organizing meaningfully**, not **filtering aggressively**.

| Mirror (wrong) | Over-filter (also wrong) | Curate (right) |
|----------------|------------------------|----------------|
| One concept per source file | One concept per domain with 500 types | One concept per meaningful unit of knowledge |
| Same directory structure as source | Only 15 types named per concept | All types named and organized |
| Analyze everything, then write | Count types in header, omit details | Full coverage with meaningful grouping |
| Single monolithic pass | Sampling/representatives only | Multiple bounded loops with intermediate artifacts |

The OKF spec (section 3) is explicit: producers organize concepts however makes sense for the knowledge being captured. The spec does **not** mandate aggressive filtering or sampling — it mandates meaningful organization.

### Coverage is a first-class concern

Every source item that represents knowledge should be **accounted for** in the bundle. A type that is not named in any concept file is **lost knowledge**, not curation. The bundle should be able to answer "what types exist in this domain?" for every domain it covers.

**Coverage target: 100% of meaningful source items should be explicitly referenced in at least one concept file.**

### Arbitrary Nesting

Bundles may nest directories to **any depth**. The spec imposes no limit — official bundles like `ga4` use 3 levels (`references/metrics/*.md`). Nest as deep as the domain requires:

- **Shallow** (1-2 levels): Small projects, simple domains — `tables/users.md`, `services/auth.md`
- **Medium** (3 levels): Moderate complexity — `apis/rest/auth/jwt.md`, `references/metrics/retention.md`
- **Deep** (4+ levels): Large or complexly-structured sources — `systems/combat/weapons/ranged/smart-bullet.md`

**When to nest deeper:**
- A directory would have more than ~15-20 concepts at one level (group them into subdirectories)
- A concept naturally belongs inside a sub-grouping (e.g. `auth/jwt` inside `services/auth`)
- The source has deep organizational structure that maps to meaningful knowledge boundaries
- Different sub-domains share a parent but have distinct internal structure

**When to stay shallow:**
- A flat list is clear and navigable (fewer than ~10 concepts per type)
- Nesting would add a level with only one child (no organizational value)
- The domain is simple enough that deep paths obscure rather than clarify

**HARD RULE — No single-child leaf folders:** A subdirectory that contains exactly one concept `.md` file and no other subdirectories MUST NOT be created. Place the concept file directly in its parent instead. This is enforced in Loop 3 (planning), checked in Loop 5 (index generation), and validated in Loop 6 (validation).

The structure planner (Loop 3) decides depth — there is no hard cap. Each directory that contains concepts or subdirectories with concepts gets its own `index.md` for progressive disclosure.

---

## Why Loops?

A monolithic approach fails for two reasons:

1. **Context overflow** — A large source directory exceeds the model's context window, causing it to lose track of what it has already written.
2. **Analysis paralysis** — Without clear stopping conditions, the model keeps analyzing without committing output.

A loop-based approach solves both by:

- Bounding each loop's context to one phase's input plus output.
- Producing an intermediate artifact after each loop that can be checked, reviewed, or fed to the next loop.
- Giving the model a clear exit condition for each loop.

---

## The Seven Loops

```
Loop 1            Loop 2             Loop 3
Pre-scan    -->   Concept       -->  Structure
                   extraction         planning
Source tree       scan_inventory      concept_manifest     bundle_plan
-> inventory      -> concept list     -> bundle layout

                                        |
                                        v

Loop 4 (repeated)                       Loop 5
Generation                         -->  Index & link
bundle_plan + one concept               All concepts
-> N concept docs                       -> indexes, links, log

                                        |
                                        v

Loop 6            Loop 7
Validate    -->   Visualize
Bundle ->         Bundle ->
conformance       viz.html
+ coverage check
```

| Loop | Input | Output | Key rule |
|------|-------|--------|----------|
| **1. Pre-scan** | Source directory path | `scan_inventory.md` — raw file list with types, sizes, one-line summaries | No analysis. Just facts. |
| **2. Concept extraction** | `scan_inventory.md` | `concept_manifest.md` — proposed concepts with type, source ref, one-line description | No writing of OKF docs. Ensure full coverage. |
| **3. Structure planning** | `concept_manifest.md` | `bundle_plan.md` — directory tree, concept-to-path mapping, index specs | No writing of OKF docs. |
| **4. Generation** (repeated) | `bundle_plan.md` + one concept from manifest | One `.md` concept file per iteration | One concept per loop iteration. List ALL member types. |
| **5. Index & link** | All generated concept files | `index.md` files, cross-links, `log.md` | Read existing docs, don't rewrite. |
| **6. Validate** | Complete bundle | Conformance report + coverage report | Run `okf_validate.py`, fix errors, verify coverage, repeat. |
| **7. Visualize** | Complete validated bundle | `viz.html` | Run `okf_visualize.py`. |

---

## Intermediate Artifacts

Each loop produces a markdown file in the bundle's staging area. These artifacts:

1. Persist state between loops so context isn't lost.
2. Allow human review between phases if desired.
3. Can be fed back as the input for the next loop.

```
<bundle-dir>/
└── .staging/
    ├── scan_inventory.md      <- Loop 1 output
    ├── concept_manifest.md    <- Loop 2 output
    └── bundle_plan.md          <- Loop 3 output
```

After loop 6, the staging area can be cleaned up.

---

## Relationship to Skills

This playbook does not replace the OKF skills. It orchestrates them:

| Skill | Used in loop |
|-------|-------------|
| `okf-build` | Loops 1-5 (the workflow steps map onto loops) |
| `okf-validate` | Loop 6 |
| `okf-visualization` | Loop 7 |
| `okf-search` | Post-generation consumption (see `query playbook.md`) |

The `okf-build` skill's 8-step workflow maps to loops as follows:

| Build step | Maps to loop |
|-----------|-------------|
| 1. Inspect the source | Loop 1 (Pre-scan) |
| 2. Determine scope and layout | Loops 2 + 3 (Concept extraction + Structure planning) |
| 3. Create concept documents | Loop 4 (Generation, repeated) |
| 4. Cross-link concepts | Loop 5 (Index & link) |
| 5. Generate index.md | Loop 5 |
| 6. Generate log.md | Loop 5 |
| 7. Declare version | Loop 5 |
| 8. Validate | Loop 6 |

---

## Loop Detail Files

Each loop has a dedicated instruction file in `loops/`. Read one at a time and follow it:

| Loop | File |
|------|------|
| 1. Pre-scan | [loops/loop-1-pre-scan.md](loops/loop-1-pre-scan.md) |
| 2. Concept extraction | [loops/loop-2-concept-extraction.md](loops/loop-2-concept-extraction.md) |
| 3. Structure planning | [loops/loop-3-structure-planning.md](loops/loop-3-structure-planning.md) |
| 4. Generation (per concept) | [loops/loop-4-generation.md](loops/loop-4-generation.md) |
| 5. Index & link | [loops/loop-5-index-link.md](loops/loop-5-index-link.md) |
| 6. Validate | [loops/loop-6-validate.md](loops/loop-6-validate.md) |
| 7. Visualize | [loops/loop-7-visualize.md](loops/loop-7-visualize.md) |

## Scripts

`scripts/` contains helper scripts that automate parts of some loops. See `scripts/index.md` for per-script usage and applicability.

**When to use a script vs. do it manually:**

- **Source-type agnostic** scripts (scan inventory, generate indexes, fix YAML) work on any source — code, docs, data, prose. Use them freely.
- **Code-oriented** scripts (`generate_concepts/` folder) use regex to extract class/struct/enum/function declarations. Each parser targets a specific language (e.g. `swift_parser.py` for Swift). They produce good results for matching code languages but poor or empty results for non-code sources (documentation, data files, spreadsheets, prose) or other languages. Check `scripts/index.md` before running a script on an unfamiliar source type. For unsupported languages, add a new parser to `generate_concepts/` or generate manually.
- **Loops 2 and 3** (concept extraction, structure planning) are never scripted because they require judgment-based curation.

If you need to make a new script and it's generic enough for reuse later, add it to `scripts/`, note its source-type applicability in `scripts/index.md`, and mention it in the relevant loop file.
