#!/usr/bin/env python3
"""
csharp_parser.py — Loop 4: Generate OKF concept documents from a concept manifest.

Usage:
    python3 csharp_parser.py <source-dir> <bundle-dir> [--manifest <path>] [--plan <path>]

Reads:
    <bundle-dir>/.staging/concept_manifest.md  (or --manifest path)
    <bundle-dir>/.staging/bundle_plan.md       (or --plan path)

Writes:
    <bundle-dir>/<dir>/<concept>.md  (one file per concept)

This script reads C# source files referenced by each concept, extracts key
declarations (classes, structs, enums, interfaces, records, delegates via regex),
and generates OKF-formatted markdown with YAML frontmatter.
"""
import os
import re
import sys
import datetime
import argparse
from collections import defaultdict


def parse_manifest(manifest_path):
    """Parse concept_manifest.md into list of concept dicts + coverage mapping."""
    with open(manifest_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    concepts = []
    in_concepts_table = False
    in_coverage_table = False
    coverage_map = defaultdict(list)  # concept_id -> [source_file, ...]
    
    for line in content.split('\n'):
        # Parse concepts table
        if line.startswith('| # |'):
            in_concepts_table = True
            in_coverage_table = False
            continue
        if in_concepts_table and line.startswith('|---|'):
            continue
        if in_concepts_table and line.startswith('|'):
            parts = [p.strip() for p in line.split('|')]
            # Columns: #, Concept ID, Type, Title, Source refs, Description, Member count, Priority
            if len(parts) >= 9:
                try:
                    num = int(parts[1])
                    cid = parts[2]
                    ctype = parts[3]
                    title = parts[4]
                    source_refs = parts[5]
                    description = parts[6]
                    member_count_str = parts[7]
                    priority = parts[8]
                    # Parse member count
                    try:
                        member_count = int(member_count_str)
                    except:
                        member_count = 0
                    concepts.append({
                        'num': num, 'id': cid, 'type': ctype, 'title': title,
                        'source_refs': source_refs, 'description': description,
                        'member_count': member_count, 'priority': priority,
                    })
                except (ValueError, IndexError):
                    pass
        elif in_concepts_table and not line.startswith('|'):
            in_concepts_table = False
        
        # Parse coverage table
        if line.startswith('| Source item') or line.startswith('|---|') and in_coverage_table:
            in_coverage_table = True
            continue
        if in_coverage_table and line.startswith('|'):
            parts = [p.strip() for p in line.split('|')]
            # Columns: Source item, Concept ID, Status
            if len(parts) >= 4 and parts[1] and parts[2] and parts[2] not in ('...','Source item','Status'):
                source_file = parts[1]
                concept_id = parts[2]
                if source_file and concept_id and not source_file.startswith('...'):
                    coverage_map[concept_id].append(source_file)
        elif in_coverage_table and not line.startswith('|'):
            in_coverage_table = False
    
    return concepts, coverage_map


def parse_plan(plan_path):
    """Parse bundle_plan.md concept->path mapping."""
    with open(plan_path, 'r', encoding='utf-8') as f:
        content = f.read()
    mapping = {}
    in_mapping = False
    for line in content.split('\n'):
        if '## Concept' in line and 'path mapping' in line:
            in_mapping = True
            continue
        if in_mapping and line.startswith('|---|'):
            continue
        if in_mapping and line.startswith('|'):
            parts = [p.strip() for p in line.split('|')]
            # Columns: Concept ID | Bundle path | Type | Title | Member count
            if len(parts) >= 6 and parts[1] and parts[2]:
                cid = parts[1]
                bpath = parts[2]
                if bpath.endswith('.md'):
                    mapping[cid] = bpath
        elif in_mapping and not line.startswith('|') and line.strip() and not line.startswith('#'):
            in_mapping = False
    return mapping


def extract_csharp_info(filepath, max_lines=50):
    """Extract class/struct/enum/interface/record/delegate names from a C# source file."""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read(max_lines * 200)  # Read up to ~max_lines worth
        
        declarations = []
        patterns = [
            (r'(?:public\s+|internal\s+|private\s+|protected\s+)?(?:sealed\s+|abstract\s+|static\s+|partial\s+)*class\s+(\w+)', 'class'),
            (r'(?:public\s+|internal\s+|private\s+|protected\s+)?(?:sealed\s+|abstract\s+|static\s+|partial\s+)*struct\s+(\w+)', 'struct'),
            (r'(?:public\s+|internal\s+|private\s+|protected\s+)?enum\s+(\w+)', 'enum'),
            (r'(?:public\s+|internal\s+|private\s+|protected\s+)?interface\s+(\w+)', 'interface'),
            (r'(?:public\s+|internal\s+|private\s+|protected\s+)?(?:sealed\s+|abstract\s+|static\s+)*record\s+(\w+)', 'record'),
            (r'(?:public\s+|internal\s+|private\s+|protected\s+)?delegate\s+(\w+)', 'delegate'),
        ]
        for pattern, dtype in patterns:
            for match in re.finditer(pattern, content):
                name = match.group(1)
                declarations.append(f'{dtype} {name}')
        
        lines = content.count('\n') + 1
        return {
            'file': os.path.basename(filepath),
            'declarations': declarations[:30],
            'lines': lines,
        }
    except Exception:
        return None


def get_source_files_for_concept(concept, coverage_map):
    """Get complete list of source files for a concept from coverage map or source_refs."""
    cid = concept['id']
    if cid in coverage_map and coverage_map[cid]:
        return coverage_map[cid]
    # Fallback: parse from source_refs
    refs = concept['source_refs']
    files = []
    for part in refs.split(','):
        part = part.strip()
        if part and not part.startswith('...') and not part.startswith('and '):
            files.append(part)
    return files


def generate_concept_doc(concept, bundle_path, source_dir, timestamp, source_files):
    """Generate a single OKF concept document."""
    cid = concept['id']
    title = concept['title']
    description = concept['description']
    priority = concept['priority']
    ctype = concept['type']
    member_count = concept['member_count']
    
    # Build tags
    tags = []
    for part in cid.split('/'):
        for word in part.split('-'):
            if word and word not in tags and len(word) > 1:
                tags.append(word)
    # Add type as tag
    if ctype and ctype.lower() not in tags:
        tags.append(ctype.lower())
    tags = tags[:10]
    
    # Build document
    doc = []
    doc.append('---')
    doc.append(f'type: "{ctype}"')
    doc.append(f'title: "{title}"')
    doc.append(f'description: "{description}"')
    if source_files:
        resource_path = source_files[0]
        # Quote if starts with special char
        if resource_path[0] in '!&*@%#>|`~{[':
            doc.append(f'resource: "{resource_path}"')
        else:
            doc.append(f'resource: "{resource_path}"')
    doc.append(f'tags: [{", ".join(tags)}]')
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
    if priority in priority_text:
        doc.append(priority_text[priority])
        doc.append('')
    
    # Read source files and extract declarations
    file_infos = []
    for sf in source_files[:30]:
        full_path = os.path.join(source_dir, sf)
        if os.path.isfile(full_path):
            info = extract_csharp_info(full_path)
            if info:
                file_infos.append(info)
    
    # Key Source Files table
    doc.append('## Key Source Files')
    doc.append('')
    doc.append(f'This concept comprises **{member_count} source files** from the WolvenKit codebase.')
    doc.append('')
    doc.append('| File | Lines | Key Declarations |')
    doc.append('|------|-------|-----------------|')
    for info in file_infos[:20]:
        decls = ', '.join(info['declarations'][:5]) if info['declarations'] else 'N/A'
        decls = decls.replace('|', '\\|')
        doc.append(f'| {info["file"]} | {info["lines"]} | {decls} |')
    doc.append('')
    
    # Member Types section - list all source files as members
    doc.append('## Member Types')
    doc.append('')
    doc.append(f'All **{member_count}** member source files assigned to this concept:')
    doc.append('')
    doc.append('| # | Source File | Type |')
    doc.append('|---|-------------|------|')
    for i, sf in enumerate(source_files, 1):
        fname = os.path.basename(sf)
        # Determine type from extension
        ext = os.path.splitext(fname)[1].lower()
        ftype = {
            '.cs': 'C#', '.py': 'Python', '.json': 'JSON', '.xml': 'XML',
            '.xaml': 'XAML', '.md': 'Markdown', '.yaml': 'YAML', '.yml': 'YAML',
            '.csproj': 'Project', '.sln': 'Solution', '.config': 'Config',
        }.get(ext, ext.lstrip('.') or 'other')
        doc.append(f'| {i} | {fname} | {ftype} |')
    doc.append('')
    
    # Architecture section
    total_lines = sum(fi['lines'] for fi in file_infos)
    if file_infos:
        doc.append('## Architecture')
        doc.append('')
        doc.append(f'The analyzed files contain approximately **{total_lines} lines** of code across **{len(file_infos)} files** (of {member_count} total).')
        doc.append('')
        # Collect unique declarations
        all_decls = set()
        for fi in file_infos:
            for d in fi['declarations']:
                all_decls.add(d)
        if all_decls:
            doc.append('### Notable Types')
            doc.append('')
            for d in sorted(all_decls)[:50]:
                doc.append(f'- {d}')
            doc.append('')
    
    # Dependencies section
    doc.append('## Dependencies')
    doc.append('')
    # Extract using statements
    using_set = set()
    for fi in file_infos[:10]:
        full_path = os.path.join(source_dir, [sf for sf in source_files if os.path.basename(sf) == fi['file']][0] if any(os.path.basename(sf) == fi['file'] for sf in source_files) else source_files[0])
        try:
            with open(full_path, 'r', encoding='utf-8', errors='replace') as f:
                for line in f:
                    if line.strip().startswith('using '):
                        using_set.add(line.strip().rstrip(';'))
                    elif not line.strip().startswith('using') and line.strip() and not line.strip().startswith('//') and not line.strip().startswith('/*') and not line.strip().startswith('['):
                        break
        except:
            pass
    if using_set:
        doc.append('Key namespace dependencies:')
        doc.append('')
        for u in sorted(using_set)[:20]:
            doc.append(f'- {u}')
        doc.append('')
    else:
        doc.append('No specific namespace dependencies detected in analyzed files.')
        doc.append('')
    
    # Citations
    doc.append('## Citations')
    doc.append('')
    doc.append(f'[1] Source files under `{source_files[0].rsplit("/", 1)[0] if "/" in source_files[0] else "."}/` in the WolvenKit repository')
    doc.append('')
    
    return '\n'.join(doc)


def main():
    parser = argparse.ArgumentParser(description='Generate OKF concept documents from manifest')
    parser.add_argument('source_dir', help='Source directory')
    parser.add_argument('bundle_dir', help='Bundle directory')
    parser.add_argument('--manifest', default=None, help='Path to concept_manifest.md')
    parser.add_argument('--plan', default=None, help='Path to bundle_plan.md')
    args = parser.parse_args()
    
    source_dir = os.path.abspath(args.source_dir)
    bundle_dir = os.path.abspath(args.bundle_dir)
    
    manifest_path = args.manifest or os.path.join(bundle_dir, '.staging', 'concept_manifest.md')
    plan_path = args.plan or os.path.join(bundle_dir, '.staging', 'bundle_plan.md')
    
    print(f"Source dir: {source_dir}")
    print(f"Bundle dir: {bundle_dir}")
    print(f"Manifest: {manifest_path}")
    print(f"Plan: {plan_path}")
    
    # Parse manifest and plan
    concepts, coverage_map = parse_manifest(manifest_path)
    path_mapping = parse_plan(plan_path)
    
    print(f"Parsed {len(concepts)} concepts from manifest")
    print(f"Parsed {len(coverage_map)} concept->files mappings from coverage table")
    print(f"Parsed {len(path_mapping)} path mappings from plan")
    
    timestamp = datetime.datetime.now().isoformat() + 'Z'
    
    generated = 0
    errors = 0
    skipped = 0
    
    for i, concept in enumerate(concepts):
        cid = concept['id']
        
        # Get bundle path from plan
        if cid in path_mapping:
            bundle_path = path_mapping[cid]
        else:
            # Fallback: construct from concept ID
            bundle_path = cid + '.md'
            skipped += 1
            continue
        
        # Get source files
        source_files = get_source_files_for_concept(concept, coverage_map)
        if not source_files:
            # Try parsing from source_refs directly
            refs = concept['source_refs']
            for part in refs.split(','):
                part = part.strip()
                if part and not part.startswith('...') and not part.startswith('and '):
                    source_files.append(part)
        
        if not source_files:
            errors += 1
            if errors <= 5:
                print(f"  ERROR: No source files for concept {cid}")
            continue
        
        # Generate document
        try:
            doc_content = generate_concept_doc(concept, bundle_path, source_dir, timestamp, source_files)
            
            # Write file
            full_path = os.path.join(bundle_dir, bundle_path)
            os.makedirs(os.path.dirname(full_path), exist_ok=True)
            with open(full_path, 'w', encoding='utf-8') as f:
                f.write(doc_content)
            
            generated += 1
            if (i + 1) % 50 == 0:
                print(f"Generated {i+1}/{len(concepts)} concepts... ({generated} written)")
        except Exception as e:
            errors += 1
            if errors <= 10:
                print(f"  ERROR generating {cid}: {e}")
    
    print(f"\nDone! Generated {generated} concept files, {errors} errors, {skipped} skipped (no path mapping)")
    print(f"Output directory: {bundle_dir}")


if __name__ == '__main__':
    main()
