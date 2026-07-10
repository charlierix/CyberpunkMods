#!/usr/bin/env python3
"""
okf_fix_yaml_resources.py — Fix unquoted YAML frontmatter values that break parsing.

Usage:
    python3 okf_fix_yaml_resources.py <bundle-dir> [--dry-run]

This script fixes a common YAML parsing error in OKF concept files where the
`resource:` field contains a value starting with `!` (e.g. `!adamsmasher/...`).
YAML interprets `!` as a tag prefix, causing a parse error. The fix is to wrap
the value in double quotes.

It also detects other potentially problematic unquoted values (values starting
with special YAML characters: !, &, *, @, %, #, >, |, {, [, `, ~).

Use --dry-run to preview changes without writing.
"""
import os
import re
import sys
import argparse


# YAML special characters that cause parsing issues when unquoted
YAML_SPECIAL_CHARS = '!&*@%#>|{[`~'


def fix_frontmatter_value(line):
    """
    Fix a single frontmatter line if the value starts with a YAML special char.
    Returns the fixed line, or the original if no fix needed.
    """
    # Match: key: value  (value not already quoted)
    match = re.match(r'^(\w+):\s*(.+)$', line)
    if not match:
        return line

    key = match.group(1)
    val = match.group(2).strip()

    # Already quoted
    if (val.startswith('"') and val.endswith('"')) or (val.startswith("'") and val.endswith("'")):
        return line

    # Check if value starts with a special char
    if val and val[0] in YAML_SPECIAL_CHARS:
        return f'{key}: "{val}"'

    return line


def process_file(filepath, dry_run=False):
    """Process a single .md file, fixing frontmatter values. Returns True if changed."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if not content.startswith('---'):
        return False

    end = content.find('---', 3)
    if end == -1:
        return False

    fm_text = content[3:end]
    lines = fm_text.split('\n')
    changed = False
    new_lines = []

    for line in lines:
        fixed = fix_frontmatter_value(line)
        if fixed != line:
            changed = True
        new_lines.append(fixed)

    if not changed:
        return False

    new_fm = '\n'.join(new_lines)
    new_content = content[:3] + new_fm + content[end:]

    if not dry_run:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)

    return True


def main():
    parser = argparse.ArgumentParser(description='Fix unquoted YAML frontmatter values that break parsing.')
    parser.add_argument('bundle_dir', help='Bundle directory path')
    parser.add_argument('--dry-run', action='store_true', help='Preview changes without writing')
    args = parser.parse_args()

    bundle_dir = os.path.abspath(args.bundle_dir)
    fixed_count = 0
    checked = 0

    for root, dirs, files in os.walk(bundle_dir):
        if '.staging' in root:
            continue
        for f in files:
            if f.endswith('.md') and f != 'index.md' and f != 'log.md':
                filepath = os.path.join(root, f)
                checked += 1
                if process_file(filepath, args.dry_run):
                    fixed_count += 1
                    rel = os.path.relpath(filepath, bundle_dir)
                    action = 'Would fix' if args.dry_run else 'Fixed'
                    print(f'  {action}: {rel}')

    print(f'\nChecked {checked} files.')
    print(f'{"Would fix" if args.dry_run else "Fixed"}: {fixed_count} files.')


if __name__ == '__main__':
    main()
