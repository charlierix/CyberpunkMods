#!/usr/bin/env python3
"""
okf_scan_inventory.py — Loop 1: Pre-scan source directory and produce a raw inventory.

Usage:
    python3 okf_scan_inventory.py <source-dir> <bundle-dir>

Output:
    <bundle-dir>/.staging/scan_inventory.md

This script walks the source directory, collects file metadata (type, size,
line count, one-line summary), and writes a markdown inventory table with a
directory tree. No analysis or concept extraction is performed — just facts.
"""
import os
import subprocess
import datetime
import sys
import mimetypes


def get_file_type(rel_path):
    """Classify a file by extension into one of: code, doc, config, data, test, schema, other."""
    ext = os.path.splitext(rel_path)[1].lower()
    if ext == '.swift':
        return 'test' if '/test' in rel_path.lower() or rel_path.startswith('tests/') else 'code'
    if ext in ('.md', '.txt', '.rst', '.pdf', '.doc'):
        return 'doc'
    if ext in ('.json', '.yaml', '.yml', '.toml', '.ini', '.cfg', '.conf', '.xml'):
        return 'config'
    if ext in ('.csv', '.tsv', '.db', '.sqlite', '.dat'):
        return 'data'
    if ext in ('.schema', '.xsd', '.proto'):
        return 'schema'
    if ext == '.url':
        return 'other'
    if ext in ('.py', '.js', '.ts', '.c', '.cpp', '.h', '.java', '.go', '.rs', '.sh', '.bat'):
        return 'code' if '/test' not in rel_path.lower() else 'test'
    if '/test' in rel_path.lower():
        return 'test'
    return 'other'


def human_size(size_bytes):
    """Convert bytes to human-readable string (e.g. 4.2KB)."""
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_bytes < 1024:
            return f'{size_bytes:.1f}{unit}'
        size_bytes /= 1024
    return f'{size_bytes:.1f}TB'


def get_line_count(filepath):
    """Count lines in a file (binary-safe)."""
    try:
        with open(filepath, 'rb') as f:
            return sum(1 for _ in f)
    except Exception:
        return 0


def get_summary(filepath, rel_path):
    """Read first few lines and produce a single factual one-line summary."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            lines = []
            for i, line in enumerate(f):
                if i >= 10:
                    break
                lines.append(line.strip())

        if rel_path.endswith('.url'):
            for line in lines:
                if line.startswith('URL='):
                    return f'URL shortcut pointing to {line[4:]}'
            return 'URL shortcut file'

        for line in lines:
            stripped = line.strip()
            if stripped.startswith('//'):
                continue
            for kw in ['public class', 'public struct', 'public enum', 'public func',
                       'class ', 'struct ', 'enum ', 'func ', 'protocol ']:
                if kw in stripped:
                    return f'Source declaring: {stripped[:120]}'

        for line in lines:
            if line and not line.startswith('//'):
                return line[:120]

        return 'Empty file' if not lines else 'Source file'
    except Exception:
        return 'Unreadable file'


def main():
    if len(sys.argv) < 3:
        print('Usage: python3 okf_scan_inventory.py <source-dir> <bundle-dir>')
        sys.exit(1)

    source_dir = os.path.abspath(sys.argv[1])
    bundle_dir = os.path.abspath(sys.argv[2])
    staging_dir = os.path.join(bundle_dir, '.staging')
    os.makedirs(staging_dir, exist_ok=True)

    # Walk source directory
    files = []
    for root, dirs, fnames in os.walk(source_dir):
        for f in fnames:
            full = os.path.join(root, f)
            rel = os.path.relpath(full, source_dir)
            files.append((rel, full))
    files.sort(key=lambda x: x[0])

    # Count directories
    dir_count = sum(len(dirs) for _, dirs, _ in os.walk(source_dir))
    scan_date = datetime.datetime.now().strftime('%Y-%m-%dT%H:%M:%S')

    # Build markdown
    out = []
    out.append('# Source Inventory')
    out.append('')
    out.append(f'**Source path:** `{source_dir}`')
    out.append(f'**Scan date:** {scan_date}')
    out.append(f'**Total files:** {len(files)}')
    out.append(f'**Total dirs:** {dir_count}')
    out.append('')
    out.append('## File listing')
    out.append('')
    out.append('| # | Path | Type | Size | Lines | One-line summary |')
    out.append('|---|------|------|------|-------|-----------------|')

    for i, (rel, full) in enumerate(files, 1):
        ftype = get_file_type(rel)
        size = os.path.getsize(full)
        hsize = human_size(size)
        lc = get_line_count(full)
        summary = get_summary(full, rel).replace('|', '\\|')
        out.append(f'| {i} | {rel} | {ftype} | {hsize} | {lc} | {summary} |')
        if i % 200 == 0:
            print(f'Processed {i}/{len(files)}...')

    out.append('')
    out.append('## Directory tree')
    out.append('')

    result = subprocess.run(['find', source_dir, '-type', 'd'], capture_output=True, text=True)
    dirs = sorted(result.stdout.strip().split('\n'))
    out.append(f'{source_dir}/')
    for d in dirs[1:]:
        rel_d = os.path.relpath(d, source_dir)
        depth = rel_d.count(os.sep)
        name = os.path.basename(d)
        prefix = '│   ' * depth + '├── '
        out.append(f'{prefix}{name}/')

    out.append('')

    output_path = os.path.join(staging_dir, 'scan_inventory.md')
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))

    print(f'\nDone! Written to {output_path}')
    print(f'Total files: {len(files)}, Total dirs: {dir_count}')
    print(f'Output file size: {os.path.getsize(output_path)} bytes')


if __name__ == '__main__':
    main()
