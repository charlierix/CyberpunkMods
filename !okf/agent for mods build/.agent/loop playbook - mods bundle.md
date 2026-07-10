# OKF Mods Bundle — Loop Playbook

**Version 0.1**

This playbook builds an OKF knowledge bundle from the `!mods` source
folder. Unlike a standard codebase playbook, this one is **goal-driven**:
it defines what the finished bundle must look like and lets you plan your
own path there.

---

## Read These First

Read these files before starting. They define the rules and the domain:

| File | Why |
|------|-----|
| `.agent/skills/SPEC.md` | The OKF v0.1 format spec — every rule about frontmatter, structure, reserved files. This is the source of truth for format. |
| `extra instructions for mods bundle.md` | Domain-specific guidance: what to capture (game mechanic manipulations), how to cluster, how to handle duplicates, when to recurse. |
| `mods - stopped early/` | Previous attempt. Good concept taxonomy (37 concepts across 7 categories), good API surface tables. Use as a starting point but go deeper. |

---

## What You're Building

An OKF bundle where **concepts are game mechanic manipulation patterns**, not
mods.

- A mod is only interesting as an **example** of a manipulation pattern.
- A concept file documents a **technique** (e.g., hit event wrapping, TweakDB
damage record modification, custom weapon creation) and references the mods
that demonstrate it.
- The bundle should let someone answer: "What are all the ways mods
manipulate damage in Cyberpunk 2077?" — and find file references for each.

### What a concept file should contain

```markdown
---
type: Mechanic Pattern
title: Hit Event Interception
description: Wrapping ReactToHitProcess to intercept damage before it resolves.
tags: [combat, damage, hit-events]
timestamp: 2026-07-03T00:00:00Z
---

# Hit Event Interception

<one paragraph explaining the technique and what it enables>

## Approach

<how it works: which native methods are wrapped, what data structures
are involved, what the mod can do at this interception point>

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Stealthrunner | `bin/x64/plugins/cyber_engine_tweaks/mods/Stealthrunner/Modules/Combat.lua` | Wraps `ReactToHitProcess` to apply stealth multipliers |
| MeatAndSteel_ArmorOverhaul | `r6/scripts/MeatAndSteel/Combat.reds` | Intercepts hit events to apply armor damage reduction |

*12 more mods use this pattern.*

## Related Concepts

- [Damage Calculation Overrides](./damage-calc-overrides.md) —
  alternative approach via DamageManager
- [TweakDB Damage Records](../tweakdb/damage-records.md) —
  static damage value modification
```

**Key differences from the previous attempts:**

- Examples are **file references** (mod name + file path + one-line note), not
  just mod names in a table.
- Line numbers are included **only when the file is large** (100+ lines).
- Duplicates are collapsed: "*N more mods use this pattern*" instead of
  listing identical entries.
- Variation is captured as separate concept files, not hidden in a list.

---

## The Loop

Work in iterations. Each iteration makes concrete progress toward the exit
criteria. You decide how many iterations you need and what each one focuses on.

### Iteration shape

```
1. Pick a goal for this iteration
   (e.g., "process all combat concepts", "write index files",
    "validate and fix errors")

2. Do the work
   - Read source files, grep for patterns, read matched code
   - Write or update concept files
   - Update index.md files
   - Track what you've done and what's left

3. Check: did this iteration move you closer to meeting all exit criteria?
   - If yes, pick the next goal
   - If no, adjust your approach

4. Repeat until all exit criteria are met
```

### Suggested starting sequence

You don't have to follow this exactly, but it's a reasonable path:

1. **Survey** — Scan the source `!mods/` directory structure. Read the
   previous bundle's concept files to get the existing taxonomy and API
   surface tables. Note which concepts had the most mods (those need the
   deepest sub-clustering).

2. **Pick a concept category** (combat, economy, media, player, systems,
   ui, world) — start with the one you can complete most quickly to
   validate your approach.

3. **For each concept in that category:**
   - Use the previous bundle's API surface table to get grep targets.
   - Grep the listed mods' source files for those patterns.
   - Read the matched code to identify distinct manipulation approaches.
   - Cluster by approach. Collapse duplicates. Note variation.
   - Write concept files (one per distinct approach, or one flat file if
     ≤3 approaches).
   - Recurse into subfolders if a pattern would have too many mods.

4. **Move to the next category** and repeat.

5. **Index and link** — Generate `index.md` for every directory. Cross-link
   related concepts. Write `log.md`.

6. **Validate** — Run the validation script. Fix all errors. Check coverage.

7. **Visualize** — Run the visualization script.

### You can deviate

If you find a better approach mid-way (e.g., a different clustering strategy,
reorganizing the taxonomy, splitting a concept differently), do it. The exit
criteria matter, not the path.

---

## Exit Criteria

The bundle is done when **all** of these are true:

### Format (OKF conformance)

- [ ] Every `.md` file (except `index.md` and `log.md`) has YAML frontmatter
      with a non-empty `type` field.
- [ ] Every directory containing concepts has an `index.md`.
- [ ] No single-child leaf folders (a folder with exactly one concept file
      and no subdirectories — move the file up instead).
- [ ] `log.md` exists at the bundle root with dated entries.
- [ ] The bundle root `index.md` lists all top-level categories.
- [ ] Validation script (`okf_validate.py`) passes with zero errors.

### Content (game mechanic patterns, not mods)

- [ ] **Every concept file documents a manipulation technique**, not a mod.
      The title and body describe *how* a game mechanic is manipulated.
- [ ] **Examples are file references**, not mod name tables. Each example
      includes: mod folder name, source file path (relative to mod folder),
      and a one-line note. Line ranges only when the file is 100+ lines.
- [ ] **Duplicates are collapsed.** When many mods use the identical pattern,
      one representative example is shown with a count note like
      "*42 mods use this pattern."
- [ ] **Variation is captured as separate concepts.** When mods manipulate
      the same mechanic through different approaches, each approach gets its
      own concept file.
- [ ] **Recursion happens when needed.** If a concept would list too many mods
      without sub-structure, it's split into a folder with sub-concept files.
      This recurses as deep as the variation requires.

### Coverage

- [ ] **All 7 categories from the previous bundle are represented**
      (combat, economy, media, player, systems, ui, world).
- [ ] **Every source mod that contains code** (lua, red, lua+red, lua+red+arch,
      red+arch, lua+arch categories) is referenced in at least one concept
      file or explicitly accounted for (e.g., "*N mods use this identical
      pattern*").
- [ ] **Archive-only mods** (arch category) are referenced where they
      contribute to a mechanic (visual asset changes complementing system
      logic), not listed as standalone concepts.
- [ ] **No mod is left unaccounted.** If a mod doesn't fit any existing
      concept, either create a new concept for its approach or note it
      explicitly as a gap.

### Structure

- [ ] The directory tree is organized by **game system → manipulation
      approach**, not by mod name or code type.
- [ ] Cross-links exist between related concepts (e.g., damage patterns link
      to weapon patterns, TweakDB patterns link to the systems they modify).
- [ ] `index.md` files use descriptions from concept frontmatter for
      progressive disclosure.

### Verification

- [ ] `okf_validate.py` passes with zero errors.
- [ ] `okf_visualize.py` generates `viz.html` successfully.
- [ ] Spot-check: pick 3 random concept files and verify the file references
      point to real files in `!mods/`.
- [ ] Spot-check: pick 3 random source mods and verify they appear in at
      least one concept file.

---

## Tips

- **Use `set +H` in shell scripts** — the `!` in `!mods` triggers bash
  history expansion.
- **Most mod source files are small** (under 100 lines). For these, just the
  filename is enough — don't waste time on exact line numbers.
- **Many mods share identical code** (clothing, atelier stores, simple tweaks).
  Collapse these aggressively — one example with a count is better than 42
  identical entries.
- **The previous bundle's API surface tables are grep targets**, not
  knowledge. Use them to find relevant code, then read the code to understand
  the actual manipulation approach.
- **You can write intermediate artifacts** (notes, scratch files, grep
  results) to `.staging/` or anywhere temporary. These are not part of the
  bundle — clean them up when done.
- **When in doubt about OKF format**, read SPEC.md. It's the authority.

---

## Scripts

| Script | When | Path |
|--------|------|------|
| `okf_validate.py` | After all concept files are written, before declaring done | `.agent/skills/create-maintain/validate/scripts/okf_validate.py` |
| `okf_visualize.py` | After validation passes | `.agent/skills/visualization/scripts/okf_visualize.py` |

Run validation from the bundle root directory.
