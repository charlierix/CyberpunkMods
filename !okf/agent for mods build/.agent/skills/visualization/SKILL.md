---
name: okf-visualization
description: >
  Render an Open Knowledge Format (OKF) bundle as a single self-contained,
  interactive HTML graph (viz.html) — concepts as nodes coloured/sized by type,
  markdown links as edges, a wiki-style detail panel with rendered markdown plus
  "Links to" / "Cited by" backlinks, layout switching, per-type filter and search.
  Use when asked to visualize, graph, preview, or explore an OKF bundle.
triggers:
  - "visualize okf"
  - "okf graph"
  - "okf html"
  - "preview okf bundle"
  - "explore okf"
---

# OKF Visualization — Interactive HTML Graph

Generate a self-contained HTML graph of the target OKF bundle. No backend,
no install on the viewing side, no data leaves the page.

## Run

```bash
python3 scripts/okf_visualize.py <bundle-dir> [-o viz.html]
```

If `pyyaml` is missing:

```bash
python3 -m pip install --quiet pyyaml && python3 scripts/okf_visualize.py <bundle-dir>
```

The output defaults to `<bundle>/viz.html`. Pass `-o <path>` to write elsewhere.

## Options

| Flag | Default | Description |
|------|---------|-------------|
| `<bundle-dir>` | `.okf/` | Path to the OKF bundle directory |
| `-o <path>` | `<bundle>/viz.html` | Output HTML file path |
| `-t <title>` | parent/bundle name | Graph title shown in header |
| `-l <url>` | none | Optional source URL shown as a link in the header |
| `--layout <name>` | `cose` | Initial layout: `cose`, `concentric`, `breadthfirst`, `circle`, `grid` |
| `--og-image <url>` | none | Absolute URL for social-preview image (og:image / twitter:image) |

## What the graph shows

- **Nodes** — One per concept (non-reserved `.md` file). Coloured by `type`,
  sized by body length. Hover or click to inspect.
- **Edges** — Markdown links between concepts become directed edges.
- **Detail panel** — Click a node to see its rendered markdown body,
  frontmatter metadata, outgoing links ("Links to"), and backlinks
  ("Cited by").
- **Layouts** — Switch between force, concentric, breadth-first, circle,
  and grid layouts.
- **Filters** — Per-type legend chips to toggle visibility; free-text search
  to filter by title, type, description, and tags.
- **Deep linking** — URL hash (`#concept-id`) and query params (`?layout=`,
  `?select=`) are supported for sharing specific views.

## Output

The script writes a single `viz.html` file containing all data and dependencies
(via CDN scripts for cytoscape.js and marked.js). Open it in any browser.
