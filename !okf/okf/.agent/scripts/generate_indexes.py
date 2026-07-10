#!/usr/bin/env python3
"""
okf_generate_indexes.py — Loop 5: Generate index.md files, verify cross-links, write log.md.

Usage:
    python3 okf_generate_indexes.py <bundle-dir> [--source-dir <path>] [--name <title>]

Reads:
    All concept .md files in <bundle-dir> (excluding .staging/, index.md, log.md)

Writes:
    <bundle-dir>/index.md           (root index with okf_version frontmatter)
    <bundle-dir>/<dir>/index.md     (one per directory containing concepts, at any depth)
    <bundle-dir>/log.md             (change log with dated entry)

This script:
    1. Walks the bundle tree recursively to find all concept .md files
    2. Parses YAML frontmatter from each to get title and description
    3. Generates index.md at every directory level that contains concepts or subdirs with concepts
    4. Each index lists both concept files and subdirectories (with descriptions)
    5. Verifies cross-links between concept documents
    6. Writes a log.md entry describing the generation

Supports arbitrary nesting depth — index.md files are generated for every
directory in the tree that contains concepts or subdirectories with concepts.

Requirements:
    - Concept files must have YAML frontmatter with at least 'title' and 'description'
    - pyyaml not required (simple key:value parsing is used)
"""
import os
import re
import sys
import datetime
import argparse


def parse_frontmatter(filepath):
    """Parse simple YAML frontmatter (key: value pairs only)."""
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


def find_concept_files(bundle_dir):
    """Find all .md concept files, excluding index.md, log.md, and .staging/."""
    concepts = []
    for root, dirs, files in os.walk(bundle_dir):
        if '.staging' in root:
            continue
        for f in files:
            if f.endswith('.md') and f != 'index.md' and f != 'log.md':
                concepts.append(os.path.join(root, f))
    concepts.sort()
    return concepts


def build_dir_tree(bundle_dir, concept_files):
    """Build a tree of directories that contain concepts (directly or transitively).

    Returns a dict: {relative_dir_path: {'concepts': [paths], 'subdirs': set()}}
    Only includes directories that have concepts somewhere in their subtree.
    """
    tree = {}
    for cf in concept_files:
        rel = os.path.relpath(cf, bundle_dir)
        d = os.path.dirname(rel) or '.'
        # Register this concept in its directory
        if d not in tree:
            tree[d] = {'concepts': [], 'subdirs': set()}
        tree[d]['concepts'].append(cf)

        # Register all ancestor directories as having subdirs
        parts = d.split(os.sep) if d != '.' else []
        for i in range(len(parts)):
            ancestor = os.sep.join(parts[:i]) if i > 0 else '.'
            if ancestor not in tree:
                tree[ancestor] = {'concepts': [], 'subdirs': set()}
            if i < len(parts):
                child = os.sep.join(parts[:i+1])
                tree[ancestor]['subdirs'].add(child)

    return tree


def generate_root_index(bundle_dir, tree, dir_descriptions, bundle_name):
    """Generate the root index.md with okf_version frontmatter."""
    lines = [
        '---',
        'okf_version: "0.1"',
        '---',
        '',
        f'# {bundle_name}',
        '',
        f'Knowledge bundle generated from source code.',
        '',
    ]
    root_entry = tree.get('.', {'concepts': [], 'subdirs': set()})
    # List root-level concepts (if any)
    for cf in sorted(root_entry['concepts']):
        fm, _ = parse_frontmatter(cf)
        title = fm.get('title', os.path.basename(cf).replace('.md', '').replace('-', ' ').title())
        desc = fm.get('description', '')
        fname = os.path.basename(cf)
        lines.append(f'- [{title}](./{fname}) — {desc}')
    if root_entry['concepts']:
        lines.append('')
    # List subdirectories
    for sd in sorted(root_entry['subdirs']):
        count = sum(1 for c in concept_files_in_subtree(tree, sd))
        desc = dir_descriptions.get(sd, f'{count} concepts')
        lines.append(f'- [{sd.title()}](./{sd}/) — {desc} ({count} concepts)')
    lines.append('')
    return '\n'.join(lines)


def concept_files_in_subtree(tree, dir_path):
    """Yield all concept files in a directory and all its descendants."""
    for d, entry in tree.items():
        if d == dir_path or d.startswith(dir_path + os.sep) or (dir_path == '.' and d != '.'):
            yield from entry['concepts']


def generate_subdir_index(dir_path, entry, bundle_dir, all_concepts, dir_descriptions, tree):
    """Generate an index.md for a subdirectory, listing concepts and subdirs."""
    dir_name = os.path.basename(dir_path) if dir_path != '.' else 'Root'
    lines = [f'# {dir_name.title()}', '']

    desc = dir_descriptions.get(dir_path, '')
    if desc:
        lines.append(desc)
        lines.append('')

    # List concepts in this directory
    for cf in sorted(entry['concepts']):
        fm, _ = parse_frontmatter(cf)
        title = fm.get('title', os.path.basename(cf).replace('.md', '').replace('-', ' ').title())
        desc = fm.get('description', '')
        fname = os.path.basename(cf)
        lines.append(f'- [{title}](./{fname}) — {desc}')

    if entry['concepts']:
        lines.append('')

    # List subdirectories
    for sd in sorted(entry['subdirs']):
        sd_count = sum(1 for _ in concept_files_in_subtree(tree, sd))
        # Use the subdir's own index heading or description
        sd_desc = dir_descriptions.get(sd, f'{sd_count} concepts')
        sd_name = os.path.basename(sd)
        lines.append(f'- [{sd_name.title()}](./{sd_name}/) — {sd_desc}')

    if entry['subdirs']:
        lines.append('')

    return '\n'.join(lines)


def verify_cross_links(bundle_dir, concept_files):
    """Check that all markdown links in concept files point to existing files."""
    all_md = set()
    for root, dirs, files in os.walk(bundle_dir):
        if '.staging' in root:
            continue
        for f in files:
            if f.endswith('.md'):
                rel = os.path.relpath(os.path.join(root, f), bundle_dir)
                all_md.add(rel)

    broken = []
    link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]+\.md)\)')
    for cf in concept_files:
        with open(cf, 'r', encoding='utf-8') as f:
            content = f.read()
        for match in link_pattern.finditer(content):
            target = match.group(2)
            if target.startswith('/'):
                target = target[1:]
            elif target.startswith('./'):
                target = target[2:]
            if target not in all_md:
                broken.append((os.path.basename(cf), target))
    return broken


def generate_log(bundle_dir, concept_count, dir_count, source_dir=None):
    """Generate or append to log.md."""
    log_path = os.path.join(bundle_dir, 'log.md')
    date_str = datetime.datetime.now().strftime('%Y-%m-%d')

    existing = ''
    if os.path.exists(log_path):
        with open(log_path, 'r') as f:
            existing = f.read()

    lines = ['# Change Log', '']

    if existing:
        if date_str in existing:
            lines = existing.split('\n')
            return '\n'.join(lines)
        else:
            lines.append(f'## {date_str}')
            lines.append('')
            old_lines = existing.split('\n')[2:]
            lines.extend(old_lines)
    else:
        lines.append(f'## {date_str}')
        lines.append('')

    src_note = f' from source directory `{source_dir}`' if source_dir else ''
    lines.append(f'- Generated {concept_count} concept documents across {dir_count} directories{src_note}.')
    lines.append(f'- Created index.md files for root and all subdirectories (arbitrary nesting).')
    lines.append(f'- Verified cross-links between concept documents.')
    lines.append('')

    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description='Generate index.md files, verify cross-links, write log.md.')
    parser.add_argument('bundle_dir', help='Bundle directory path')
    parser.add_argument('--source-dir', help='Source directory path (for log entry)', default=None)
    parser.add_argument('--name', help='Bundle name for root index title', default='Knowledge Bundle')
    args = parser.parse_args()

    bundle_dir = os.path.abspath(args.bundle_dir)

    # Find all concept files
    concept_files = find_concept_files(bundle_dir)
    print(f'Found {len(concept_files)} concept files')

    # Build directory tree
    tree = build_dir_tree(bundle_dir, concept_files)
    print(f'Directories with concepts: {sorted(tree.keys())}')

    # Auto-generate descriptions from existing index.md files
    dir_descriptions = {}
    for d in tree:
        if d == '.':
            continue
        idx_path = os.path.join(bundle_dir, d, 'index.md')
        if os.path.exists(idx_path):
            with open(idx_path, 'r') as f:
                content = f.read()
            lines = content.split('\n')
            for line in lines[1:]:
                if line.strip() and not line.startswith('#') and not line.startswith('---'):
                    dir_descriptions[d] = line.strip()
                    break
        if d not in dir_descriptions:
            count = sum(1 for _ in concept_files_in_subtree(tree, d))
            dir_descriptions[d] = f'{count} concepts in {d}'

    # Generate root index.md
    root_index = generate_root_index(bundle_dir, tree, dir_descriptions, args.name)
    root_path = os.path.join(bundle_dir, 'index.md')
    with open(root_path, 'w', encoding='utf-8') as f:
        f.write(root_index)
    print(f'Written root index.md')

    # Generate index.md for every directory in the tree (not just top-level)
    for d, entry in sorted(tree.items()):
        if d == '.':
            continue
        idx_content = generate_subdir_index(d, entry, bundle_dir, concept_files, dir_descriptions, tree)
        idx_path = os.path.join(bundle_dir, d, 'index.md')
        os.makedirs(os.path.dirname(idx_path), exist_ok=True)
        with open(idx_path, 'w', encoding='utf-8') as f:
            f.write(idx_content)
        concept_count = len(entry['concepts'])
        subdir_count = len(entry['subdirs'])
        print(f'Written {d}/index.md ({concept_count} concepts, {subdir_count} subdirs)')

    # Verify cross-links
    broken = verify_cross_links(bundle_dir, concept_files)
    if broken:
        print(f'\nWarning: {len(broken)} broken cross-links found:')
        for src, tgt in broken[:20]:
            print(f'  {src} -> {tgt}')
    else:
        print('No broken cross-links found.')

    # Generate log.md
    dir_count = len([d for d in tree if d != '.'])
    log_content = generate_log(bundle_dir, len(concept_files), dir_count, args.source_dir)
    log_path = os.path.join(bundle_dir, 'log.md')
    with open(log_path, 'w', encoding='utf-8') as f:
        f.write(log_content)
    print(f'Written log.md')

    print(f'\n=== Loop 5 Complete ===')
    print(f'Concept files: {len(concept_files)}')
    print(f'Directories: {dir_count}')
    print(f'Broken links: {len(broken)}')


if __name__ == '__main__':
    main()
