#!/usr/bin/env python3
"""
Reweight all _index.nb.md (and matching _index.en.md) so siblings at each
directory level use weights 10, 20, 30, ... instead of 1, 2, 3, ...

Groups files by grandparent directory (files that share the same parent
directory are siblings). Within each group, sorts by current weight and
assigns new weights 10, 20, 30, ...

Files without a 'weight:' field are ignored.
"""
import os
import re
from collections import defaultdict

REPOS = [
    'S:/app-data/github/samt-x-repos/samt-bu-docs/content',
    'S:/app-data/github/samt-x-repos/team-architecture/content',
    'S:/app-data/github/samt-x-repos/team-semantics/content',
    'S:/app-data/github/samt-x-repos/samt-bu-drafts/content',
    'S:/app-data/github/samt-x-repos/solution-samt-bu-docs/content',
]


def get_weight(filepath):
    with open(filepath, encoding='utf-8') as f:
        content = f.read()
    m = re.search(r'^weight:\s*(\d+)', content, re.MULTILINE)
    return int(m.group(1)) if m else None


def set_weight(filepath, new_weight):
    with open(filepath, encoding='utf-8') as f:
        content = f.read()
    new_content = re.sub(
        r'^(weight:\s*)\d+',
        f'weight: {new_weight}',
        content,
        flags=re.MULTILINE
    )
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False


def reweight_repo(content_dir):
    # Group _index.nb.md by grandparent (siblings share same grandparent)
    groups = defaultdict(list)
    for root, dirs, files in os.walk(content_dir):
        if '_index.nb.md' in files:
            filepath = os.path.join(root, '_index.nb.md')
            grandparent = os.path.dirname(root)
            weight = get_weight(filepath)
            if weight is not None:
                groups[grandparent].append((weight, filepath))

    changes = 0
    for grandparent, siblings in sorted(groups.items()):
        siblings.sort(key=lambda x: x[0])
        for i, (old_weight, nb_path) in enumerate(siblings):
            new_weight = (i + 1) * 10
            if old_weight == new_weight:
                continue
            # Update nb file
            rel = os.path.relpath(nb_path, content_dir)
            if set_weight(nb_path, new_weight):
                print(f'  nb  {rel}: {old_weight} -> {new_weight}')
                changes += 1
            # Update matching en file
            en_path = nb_path.replace('_index.nb.md', '_index.en.md')
            if os.path.exists(en_path):
                en_old = get_weight(en_path)
                if set_weight(en_path, new_weight):
                    rel_en = os.path.relpath(en_path, content_dir)
                    print(f'  en  {rel_en}: {en_old} -> {new_weight}')
                    changes += 1
    return changes


if __name__ == '__main__':
    total = 0
    for repo in REPOS:
        print(f'\n=== {repo} ===')
        if not os.path.isdir(repo):
            print('  (ikke funnet – hopper over)')
            continue
        n = reweight_repo(repo)
        print(f'  -> {n} filer endret')
        total += n
    print(f'\nTotalt: {total} filer endret')
