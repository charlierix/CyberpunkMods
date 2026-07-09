#!/usr/bin/env python3
"""
okf_generate_concepts.py — Loop 4: Generate OKF concept documents from a concept manifest.

Usage:
    python3 okf_generate_concepts.py <source-dir> <bundle-dir> [--manifest <path>] [--plan <path>]

Reads:
    <bundle-dir>/.staging/concept_manifest.md  (or --manifest path)
    <bundle-dir>/.staging/bundle_plan.md       (or --plan path)

Writes:
    <bundle-dir>/<dir>/<concept>.md  (one file per concept)

This script reads source files referenced by each concept, extracts key
declarations (classes, structs, enums, protocols, functions via regex),
and generates OKF-formatted markdown with YAML frontmatter.

The concept manifest and bundle plan are intermediate artifacts produced
by Loops 2 and 3. This script automates Loop 4 generation.

Requirements:
    - Source files must be readable text (Swift, Python, JS, etc.)
    - Manifest and plan must follow the table format from Loops 2 and 3
"""
import os
import re
import sys
import datetime
import argparse


def parse_frontmatter(filepath):
    """Parse YAML frontmatter from a markdown file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    if not content.startswith('---'):
        return {}, content
    end = content.find('---', 3)
    if end == -1:
        return {}, content
    fm_text = content[3:end].strip()
    fm = {}
    for line in fm_text.split('\n'):
        if ':' in line:
            key, val = line.split(':', 1)
            fm[key.strip()] = val.strip().strip('"').strip("'")
    return fm, content


def parse_manifest(manifest_path):
    """Parse concept_manifest.md table into list of concept dicts."""
    with open(manifest_path, 'r', encoding='utf-8') as f:
        content = f.read()
    concepts = []
    in_table = False
    for line in content.split('\n'):
        if line.startswith('| # |'):
            in_table = True
            continue
        if in_table and line.startswith('|---|'):
            continue
        if in_table and line.startswith('|'):
            parts = [p.strip() for p in line.split('|')]
            if len(parts) >= 8:
                try:
                    num = int(parts[1])
                    cid = parts[2]
                    ctype = parts[3]
                    title = parts[4]
                    source_refs = parts[5]
                    description = parts[6]
                    priority = parts[7]
                    concepts.append({
                        'num': num, 'id': cid, 'type': ctype, 'title': title,
                        'source_refs': source_refs, 'description': description,
                        'priority': priority,
                    })
                except (ValueError, IndexError):
                    pass
        elif in_table and not line.startswith('|'):
            break
    return concepts


def parse_plan(plan_path):
    """Parse bundle_plan.md concept->path mapping."""
    with open(plan_path, 'r', encoding='utf-8') as f:
        content = f.read()
    mapping = {}
    for line in content.split('\n'):
        if line.startswith('| core/') or line.startswith('| cyberpunk/') or line.startswith('| '):
            parts = [p.strip() for p in line.split('|')]
            if len(parts) >= 6 and parts[1] and parts[2]:
                cid = parts[1]
                bpath = parts[2]
                if '/' in cid and bpath.endswith('.md'):
                    mapping[cid] = bpath
    return mapping


def extract_source_info(filepath):
    """Extract class/struct/enum/protocol/func names from a source file."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()
        declarations = []
        patterns = [
            (r'(public\s+)?class\s+(\w+)', 'class'),
            (r'(public\s+)?struct\s+(\w+)', 'struct'),
            (r'(public\s+)?enum\s+(\w+)', 'enum'),
            (r'(public\s+)?protocol\s+(\w+)', 'protocol'),
            (r'(public\s+)?func\s+(\w+)', 'func'),
        ]
        for pattern, dtype in patterns:
            for match in re.finditer(pattern, content):
                name = match.group(2)
                declarations.append(f'{dtype} {name}')
        lines = content.count('\n') + 1
        return {
            'file': os.path.basename(filepath),
            'declarations': declarations[:20],
            'lines': lines,
        }
    except Exception:
        return None


def generate_concept_doc(concept, bundle_path, source_dir, timestamp):
    """Generate a single OKF concept document."""
    cid = concept['id']
    title = concept['title']
    description = concept['description']
    priority = concept['priority']
    ctype = concept['type']

    # Parse source refs
    source_files = [s.strip() for s in concept['source_refs'].split(',')]
    source_files = [s for s in source_files if s and not s.startswith('...') and not s.startswith('and')]

    # Read key source files
    file_infos = []
    for sf in source_files[:20]:
        full_path = os.path.join(source_dir, sf)
        if os.path.isfile(full_path):
            info = extract_source_info(full_path)
            if info:
                file_infos.append(info)

    # Build tags
    tags = []
    for part in cid.split('/'):
        for word in part.split('-'):
            if word and word not in tags:
                tags.append(word)
    for word in title.replace('(Core)', '').replace('(Cyberpunk)', '').strip().split():
        w = word.lower().rstrip('s')
        if w and w not in tags and len(w) > 2:
            tags.append(w)

    # Build document
    doc = []
    doc.append('---')
    doc.append(f'type: {ctype}')
    doc.append(f'title: "{title}"')
    doc.append(f'description: "{description}"')
    if source_files:
        doc.append(f'resource: "!{source_files[0]}"')
    doc.append(f'tags: {tags[:8]}')
    doc.append(f'timestamp: {timestamp}')
    doc.append('---')
    doc.append('')
    doc.append('## Overview')
    doc.append('')
    doc.append(description)
    doc.append('')
    priority_text = {
        'high': 'This is a **core subsystem** essential for functionality.',
        'medium': 'This is a **supporting subsystem** that enhances functionality.',
        'low': 'This is a **peripheral subsystem** with limited scope.',
    }
    doc.append(priority_text.get(priority, ''))
    doc.append('')

    # Key Source Files table
    doc.append('## Key Source Files')
    doc.append('')
    doc.append('| File | Lines | Key Declarations |')
    doc.append('|------|-------|-----------------|')
    for info in file_infos[:15]:
        decls = ', '.join(info['declarations'][:5]) if info['declarations'] else 'N/A'
        decls = decls.replace('|', '\\|')
        doc.append(f'| {info["file"]} | {info["lines"]} | {decls} |')
    doc.append('')

    # Architecture section
    doc.append('## Architecture')
    doc.append('')
    total_lines = sum(fi['lines'] for fi in file_infos)
    doc.append(f'This subsystem comprises **{len(source_files)} source files** with approximately **{total_lines} lines** of code across the analyzed files.')
    doc.append('')

    # Notable types
    all_decls = set()
    for info in file_infos:
        for d in info['declarations']:
            all_decls.add(d)
    if all_decls:
        doc.append('### Notable Types and Functions')
        doc.append('')
        decl_groups = {}
        for d in all_decls:
            dtype = d.split()[0] if ' ' in d else 'other'
            decl_groups.setdefault(dtype, []).append(d.split()[-1] if ' ' in d else d)
        for dtype in ['class', 'struct', 'enum', 'protocol', 'func']:
            if dtype in decl_groups and decl_groups[dtype]:
                names = sorted(set(decl_groups[dtype]))
                doc.append(f'**{dtype.title()}s:** {", ".join(names[:15])}')
                if len(names) > 15:
                    doc.append(f' *...and {len(names) - 15} more*')
                doc.append('')

    # Dependencies
    doc.append('## Dependencies')
    doc.append('')
    doc.append('- Referenced by multiple subsystems in the bundle.')
    doc.append('')

    # Citations
    doc.append('## Citations')
    doc.append('')
    for sf in source_files[:10]:
        doc.append(f'- `{sf}`')
    if len(source_files) > 10:
        doc.append(f'- *...and {len(source_files) - 10} more source files*')
    doc.append('')

    return '\n'.join(doc)


def main():
    parser = argparse.ArgumentParser(description='Generate OKF concept documents from manifest and plan.')
    parser.add_argument('source_dir', help='Source directory path')
    parser.add_argument('bundle_dir', help='Bundle directory path')
    parser.add_argument('--manifest', help='Path to concept_manifest.md (default: <bundle>/.staging/concept_manifest.md)')
    parser.add_argument('--plan', help='Path to bundle_plan.md (default: <bundle>/.staging/bundle_plan.md)')
    args = parser.parse_args()

    source_dir = os.path.abspath(args.source_dir)
    bundle_dir = os.path.abspath(args.bundle_dir)
    manifest_path = args.manifest or os.path.join(bundle_dir, '.staging', 'concept_manifest.md')
    plan_path = args.plan or os.path.join(bundle_dir, '.staging', 'bundle_plan.md')

    concepts = parse_manifest(manifest_path)
    path_mapping = parse_plan(plan_path)

    print(f'Parsed {len(concepts)} concepts from manifest')
    print(f'Parsed {len(path_mapping)} path mappings from plan')

    timestamp = datetime.datetime.now().strftime('%Y-%m-%dT%H:%M:%SZ')
    generated = 0
    errors = []

    for concept in concepts:
        cid = concept['id']
        if cid not in path_mapping:
            errors.append(f'No path mapping for {cid}')
            continue

        bundle_path = path_mapping[cid]
        full_path = os.path.join(bundle_dir, bundle_path)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)

        doc_content = generate_concept_doc(concept, bundle_path, source_dir, timestamp)

        with open(full_path, 'w', encoding='utf-8') as f:
            f.write(doc_content)

        generated += 1
        if generated % 10 == 0:
            print(f'Generated {generated}/{len(concepts)}...')

    print(f'\nDone! Generated {generated} concept documents.')
    if errors:
        print(f'Errors: {len(errors)}')
        for e in errors:
            print(f'  {e}')


if __name__ == '__main__':
    main()
