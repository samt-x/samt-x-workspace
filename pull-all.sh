#!/usr/bin/env bash
# Oppdaterer alle git-repoer under denne mappen.
# Kjør fra S:\app-data\github\samt-x-repos\ eller med full sti.

ROOT="$(cd "$(dirname "$0")" && pwd)"

for d in "$ROOT"/*/; do
  name=$(basename "$d")
  echo "=== $name ==="
  git -C "$d" pull
  # Oppdater submoduler (kun samt-bu-docs har submoduler per nå)
  if [ -f "$d/.gitmodules" ]; then
    git -C "$d" submodule update --recursive
  fi
  echo ""
done

echo "Ferdig."
