# Loop 5: Index & Link

**Goal:** After all concept documents exist, generate `index.md` files, verify cross-links, and write `log.md`.

---

## Input

- Complete bundle with all concept `.md` files (from Loop 4)
- `bundle_plan.md` from Loop 3 (for index specs and cross-link plan)

## Output

- `index.md` in every directory of the bundle
- `log.md` at the bundle root
- Updated cross-links in concept docs (if any were missed during generation)

## index.md format

`index.md` files have **no frontmatter** (except the bundle root, which may carry `okf_version`).

### Bundle root index.md

```markdown
---
okf_version: "0.1"
---

# <Bundle Name>

Knowledge bundle for <project/domain>.

- [Services](./services/) — Service definitions and APIs
- [Tables](./tables/) — Database tables and datasets
- [Metrics](./metrics/) — Business metrics and KPIs
- [Playbooks](./playbooks/) — Operational procedures
```

### Subdirectory index.md (with nested subdirectories)

For directories that contain both concepts and subdirectories, list both:

```markdown
# Services

- [Auth](./auth/) — Authentication subsystem (2 concepts)
- [Payment](./payment/) — Payment processing subsystem (2 concepts)
```

For leaf directories (concepts only, no subdirectories):

```markdown
# Auth

- [JWT](./jwt.md) — JWT token generation and validation.
- [Permissions](./permissions.md) — Role-based permission checking.
```

Each entry should use the concept's `description` from its frontmatter.

## log.md format

```markdown
# Change Log

## 2026-06-28

- Initial bundle generation from source directory `/path/to/source`.
- Created N concept documents across M directories.
- Generated index.md files and cross-links.
```

## Script assistance (optional)

The `generate_indexes.py` script can automate this loop by scanning concept `.md` files, parsing frontmatter, generating root and subdirectory `index.md` files, verifying cross-links, and writing `log.md`. It operates on the generated bundle (not the source), so it works regardless of source type. See `scripts/index.md` for usage.

## Instructions

1. **List all concept files** in the bundle:
   ```bash
   find <bundle-dir> -name '*.md' -not -name 'index.md' -not -name 'log.md' | sort
   ```

2. **Generate root index.md**:
   - List all top-level directories that contain concepts or subdirectories with concepts.
   - For each, write a link and one-line description.
   - Add `okf_version: "0.1"` to frontmatter.

3. **Generate index.md at every level** — not just top-level directories:
   - Walk the entire bundle directory tree.
   - For **each directory** that contains concept `.md` files or subdirectories with concepts, generate an `index.md`.
   - For each concept `.md` file in the directory, read its frontmatter to get `title` and `description`.
   - Write a link entry: `- [Title](./file.md) — description`
   - For each **subdirectory** that contains concepts (directly or transitively), write a link entry: `- [Subdirectory](./subdir/) — description`
   - Subdirectory descriptions can be derived from the subdirectory's own `index.md` heading or the types of concepts it contains.

4. **Verify cross-links**:
   - Scan all concept files for markdown links to other concepts.
   - Check that each link target exists in the bundle.
   - Broken links are **tolerated by the spec** (section 5.3) — don't delete them, but log them as warnings.
   - If a link from the bundle plan was missed during generation, add it now.

5. **Write log.md** with a dated entry describing the initial generation.

6. **Do NOT rewrite concept documents.** Only add missing cross-links if needed. The concept docs from Loop 4 are the source of truth.

## Single-child leaf folder check

Before generating index files, verify that no directory contains exactly one concept `.md` file and no subdirectories. If any are found, flatten them (move the concept file to the parent and remove the now-empty subdirectory) before proceeding with index generation. This enforces the hard rule from Loop 3.

## What NOT to do

- Do NOT add frontmatter to subdirectory `index.md` files.
- Do NOT rewrite or restructure concept documents.
- Do NOT create `index.md` files in directories that have no concepts.
- Do NOT create subdirectories for single concepts — flatten single-child leaf folders (see the hard rule in Loop 3).
- Do NOT run validation — that's Loop 6.

## Stop condition

**Stop when all `index.md` files and `log.md` are written and cross-links have been verified.** Do not proceed to validation.
