# Loop 7: Visualize

**Goal:** Generate an interactive HTML graph of the completed, validated OKF bundle.

---

## Input

- Complete, validated OKF bundle (from Loop 6)

## Output

A single self-contained HTML file written to:
```
<bundle-dir>/viz.html
```

## Instructions

1. **Run the visualization script:**

   ```bash
   python3 "<bundle-dir>/.agent/skills/visualization/scripts/okf_visualize.py" <bundle-dir>
   ```

   If `pyyaml` is missing:
   ```bash
   python3 -m pip install --quiet pyyaml && python3 "<bundle-dir>/.agent/skills/visualization/scripts/okf_visualize.py" <bundle-dir>
   ```

2. **Optional flags:**

   | Flag | Default | Description |
   |------|---------|-------------|
   | `-o <path>` | `<bundle>/viz.html` | Output HTML file path |
   | `-t <title>` | parent/bundle name | Graph title shown in header |
   | `-l <url>` | none | Optional source URL shown as a link in the header |
   | `--layout <name>` | `cose` | Initial layout: `cose`, `concentric`, `breadthfirst`, `circle`, `grid` |

   Example with options:
   ```bash
   python3 "<bundle-dir>/.agent/skills/visualization/scripts/okf_visualize.py" <bundle-dir> -t "My Project Knowledge" --layout breadthfirst
   ```

3. **Verify output:**

   Check that `viz.html` was created:
   ```bash
   ls -la <bundle-dir>/viz.html
   ```

4. **Report results:**

   ```
   Visualization generated: <bundle-dir>/viz.html
   File size: <N>KB
   Concepts visualized: <N> nodes
   Cross-links rendered: <N> edges
   ```

## What the graph shows

- **Nodes** — One per concept, coloured by `type`, sized by body length.
- **Edges** — Markdown links between concepts become directed edges.
- **Detail panel** — Click a node to see rendered markdown body, frontmatter, outgoing links, and backlinks.
- **Layouts** — Switch between force, concentric, breadth-first, circle, and grid.
- **Filters** — Per-type legend chips to toggle visibility; free-text search.

## What NOT to do

- Do NOT skip this loop. Visualization is the final step that makes the bundle explorable.
- Do NOT modify any bundle files. This loop only reads.
- Do NOT install heavy dependencies. The script only needs `pyyaml`.

## Stop condition

**Stop when `viz.html` exists in the bundle directory and the script completed without errors.**

The bundle build pipeline is now complete.
