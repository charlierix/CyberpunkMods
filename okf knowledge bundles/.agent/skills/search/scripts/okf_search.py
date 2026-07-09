#!/usr/bin/env python3
"""Search and query an OKF bundle by frontmatter fields and full-text.

Run:  python3 okf_search.py <bundle-dir> [filters] [--json]
"""
from __future__ import annotations
import argparse, json, re, sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("pyyaml is required: pip install pyyaml", file=sys.stderr)
    sys.exit(2)

RESERVED = {"index.md", "log.md"}
LINK = re.compile(r"(?<!\!)\[[^\]]*\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")


def split_frontmatter(text: str):
    if not text.startswith("---"):
        return {}, text
    lines = text.splitlines(keepends=True)
    if lines[0].strip() != "---":
        return {}, text
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            try:
                meta = yaml.safe_load("".join(lines[1:i])) or {}
            except yaml.YAMLError:
                meta = {}
            return (meta if isinstance(meta, dict) else {}), "".join(lines[i + 1:])
    return {}, text


def load_bundle(bundle: Path):
    results = []
    for p in sorted(bundle.rglob("*.md")):
        if p.name in RESERVED:
            continue
        text = p.read_text(encoding="utf-8").lstrip("\ufeff")
        meta, body = split_frontmatter(text)
        cid = p.relative_to(bundle).with_suffix("").as_posix()
        results.append({
            "id": cid,
            "path": p.relative_to(bundle).as_posix(),
            "type": str(meta.get("type", "")),
            "title": str(meta.get("title", "")),
            "description": str(meta.get("description", "")),
            "tags": meta.get("tags", []) if isinstance(meta.get("tags"), list) else [],
            "resource": str(meta.get("resource", "")),
            "timestamp": str(meta.get("timestamp", "")),
            "body": body.strip(),
            "links": [t for t in LINK.findall(body) if t.endswith(".md")],
        })
    return results


def main():
    ap = argparse.ArgumentParser(description="Search an OKF bundle.")
    ap.add_argument("bundle", type=Path, help="path to the bundle directory")
    ap.add_argument("--type", default=None, help="filter by type (substring, case-insensitive)")
    ap.add_argument("--tag", default=None, help="filter by tag (exact match)")
    ap.add_argument("--title", default=None, help="filter by title (substring, case-insensitive)")
    ap.add_argument("--desc", default=None, help="filter by description (substring, case-insensitive)")
    ap.add_argument("--text", default=None, help="full-text search in body (case-insensitive)")
    ap.add_argument("--json", action="store_true", help="output as JSON")
    ap.add_argument("--list-types", action="store_true", help="list unique types and counts")
    ap.add_argument("--list-tags", action="store_true", help="list unique tags and counts")
    args = ap.parse_args()

    if not args.bundle.is_dir():
        print(f"error: {args.bundle} is not a directory", file=sys.stderr)
        return 2

    concepts = load_bundle(args.bundle)

    if args.list_types:
        counts = {}
        for c in concepts:
            t = c["type"] or "(untyped)"
            counts[t] = counts.get(t, 0) + 1
        if args.json:
            print(json.dumps(counts, indent=2))
        else:
            for t, n in sorted(counts.items(), key=lambda x: -x[1]):
                print(f"  {t}: {n}")
        return 0

    if args.list_tags:
        counts = {}
        for c in concepts:
            for tag in c["tags"]:
                counts[tag] = counts.get(tag, 0) + 1
        if args.json:
            print(json.dumps(counts, indent=2))
        else:
            for t, n in sorted(counts.items(), key=lambda x: -x[1]):
                print(f"  {t}: {n}")
        return 0

    filtered = concepts
    if args.type:
        filtered = [c for c in filtered if args.type.lower() in c["type"].lower()]
    if args.tag:
        filtered = [c for c in filtered if args.tag in c["tags"]]
    if args.title:
        filtered = [c for c in filtered if args.title.lower() in c["title"].lower()]
    if args.desc:
        filtered = [c for c in filtered if args.desc.lower() in c["description"].lower()]
    if args.text:
        filtered = [c for c in filtered if args.text.lower() in c["body"].lower()]

    if args.json:
        out = [{k: v for k, v in c.items() if k != "body"} | {"body_preview": c["body"][:200]} for c in filtered]
        print(json.dumps(out, indent=2))
    else:
        print(f"Found {len(filtered)} concept(s) in {args.bundle}")
        for c in filtered:
            print(f"  {c['id']}  [{c['type']}]  {c['title']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
