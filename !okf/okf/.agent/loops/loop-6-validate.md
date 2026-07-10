# Loop 6: Validate

**Goal:** Run the deterministic OKF conformance checker, fix any hard errors, verify coverage, and confirm the bundle is conformant.

---

## Input

- Complete OKF bundle (all concept files, index.md files, log.md)
- `concept_manifest.md` from Loop 2 (for coverage verification)

## Output

- Conformance report (printed to stdout)
- Coverage report (printed to stdout)
- Fixed concept files (if any errors were found)

## Instructions

### Part A: OKF Conformance

1. **Run the validator:**

   ```bash
   python3 "<bundle-dir>/.agent/skills/create-maintain/validate/scripts/okf_validate.py" <bundle-dir> --json
   ```

   If `pyyaml` is missing:
   ```bash
   python3 -m pip install --quiet pyyaml && python3 "<bundle-dir>/.agent/skills/create-maintain/validate/scripts/okf_validate.py" <bundle-dir> --json
   ```

2. **Review the report.**

   The checker reports:

   | Severity | Code | Meaning |
   |----------|------|---------|
   | **ERROR** | E1 | File has no parseable YAML frontmatter |
   | **ERROR** | E2 | Frontmatter missing or empty `type` field |
   | **warn** | W1 | Recommended field absent (title, description, tags, timestamp) |
   | **warn** | W2 | Cross-link target not found (tolerated by spec) |
   | **warn** | W3 | index.md has unexpected frontmatter |
   | **warn** | W4 | log.md has frontmatter or non-ISO date headings |

3. **Fix every ERROR (E1, E2):**

   - **E1 (no frontmatter):** Add a `---`-delimited YAML block at the top of the file with at minimum a `type` field.
   - **E2 (empty type):** Set `type` to a descriptive non-empty string.

4. **Fix warnings when cheap:**

   - W1: Add missing `title`, `description`, `tags`, or `timestamp` to frontmatter.
   - W2: Leave broken links as-is (spec tolerates them) unless the target was just misnamed.
   - W3: Remove frontmatter from subdirectory `index.md` files (only root can have `okf_version`).
   - W4: Remove frontmatter from `log.md`; fix date headings to `YYYY-MM-DD` format.

5. **Re-run the validator** after fixes. Repeat until zero ERRORs.

### Part B: Coverage Verification

6. **Verify source coverage.** After conformance passes, verify that every meaningful source item from the manifest is explicitly referenced in at least one concept file.

   Method:
   ```bash
   # Extract all type names mentioned across all concept files
   grep -ohP '\b[A-Z][A-Za-z0-9_]+\b' <bundle-dir>/**/*.md | sort -u > /tmp/bundle_types.txt
   
   # Extract all type names from the source index
   python3 -c "
   import json, sys
   with open('<source-dir>/index.json') as f:
       idx = json.load(f)
   for entry in idx:
       print(entry.get('name', entry.get('type', '')))
   " | sort -u > /tmp/source_types.txt
   
   # Find source types NOT mentioned in any bundle file
   comm -23 /tmp/source_types.txt /tmp/bundle_types.txt > /tmp/missing_types.txt
   echo "Missing types: $(wc -l < /tmp/missing_types.txt)"
   cat /tmp/missing_types.txt | head -50
   ```

   Adjust the source-type extraction method based on the source format (JSON, code, CSV, etc.).

7. **Assess coverage.**

   | Coverage | Status | Action |
   |----------|--------|--------|
   | 95-100% | Good | Proceed to visualization |
   | 80-94% | Acceptable | Note gaps in report, proceed to visualization |
   | <80% | Poor | Go back to Loops 2-4 and add missing types |

8. **Report results:**

   ```
   Bundle is OKF v0.1 conformant

   Errors: 0
   Warnings: <N> (non-blocking)

   Concepts: <N>
   Directories: <N>
   Total .md files: <N>
   
   Coverage: <N>% (<N> of <N> source types referenced)
   Missing types: <N>
   ```

## Part C: Single-Child Leaf Folder Check

After conformance and coverage pass, verify that no directory in the bundle contains exactly one concept `.md` file and no subdirectories. Such directories violate the hard rule from Loop 3.

Method:
```bash
find <bundle-dir> -type d -not -path '*/.staging*' -not -path '*/.agent*' | while read dir; do
  concept_count=$(find "$dir" -maxdepth 1 -name '*.md' ! -name 'index.md' ! -name 'log.md' | wc -l)
  subdir_count=$(find "$dir" -maxdepth 1 -type d -not -path "$dir" | wc -l)
  if [ "$subdir_count" -eq 0 ] && [ "$concept_count" -eq 1 ]; then
    echo "SINGLE-CHILD LEAF: $dir"
  fi
done
```

If any single-child leaf folders are found:
1. Move the concept `.md` file to the parent directory.
2. Delete the now-empty subdirectory (including its `index.md`).
3. Regenerate `index.md` files for affected directories.
4. Re-run conformance validation.

## What NOT to do

- Do NOT use the model's judgment instead of the validator script. The validator is deterministic.
- Do NOT delete files to make errors go away. Fix them.
- Do NOT treat warnings as failures. The spec is permissive by design.
- Do NOT skip coverage verification. Coverage is a first-class quality metric.
- Do NOT skip the single-child leaf folder check. It is a structural quality rule.
- Do NOT skip this loop. Validation is the final gate before the bundle is usable.

## Stop condition

**Stop when the validator reports zero ERRORs AND coverage is >=80%.** Warnings are acceptable. If coverage is below 80%, go back to Loop 2 and add missing concepts/members.

If errors persist after 3 fix iterations, stop and report the remaining errors for manual resolution.
