#!/usr/bin/env bash
# Viser git-status for workspace-repoet og alle under-repoene, én linje per repo.
# Repoer med lokale endringer får filene listet under seg.
# Brukes ved «Start sesjon» og før «Avslutt sesjon». Endrer ingenting.
#
#   bash S:/app-data/github/samt-x-repos/status-all.sh          # bare lokal tilstand
#   bash S:/app-data/github/samt-x-repos/status-all.sh --fetch  # hent fra GitHub først, så «behind» stemmer
#
# Løkken ligger her med vilje: Claude Code kan ikke sjekke stier som beregnes
# når en kommando kjører, og spør da hver gang. Et fast skript med fast sti
# slipper gjennom (workspace-minnet feedback_faste-stier-i-kommandoer.md).

ROOT="$(cd "$(dirname "$0")" && pwd)"
FETCH=0
[ "$1" = "--fetch" ] && FETCH=1

dirty=0
show() {
  local dir="$1" name="$2"
  [ "$FETCH" = 1 ] && git -C "$dir" fetch -q 2>/dev/null
  local head
  head=$(git -C "$dir" status -sb 2>&1 | head -1)
  printf "%-28s %s\n" "$name" "$head"
  local changes
  changes=$(git -C "$dir" status --porcelain 2>/dev/null)
  if [ -n "$changes" ]; then
    echo "$changes" | sed 's/^/      /'
    dirty=$((dirty + 1))
  fi
  # Temaet i samt-bu-docs er submodule og havner lett i detached HEAD
  if [ -f "$dir/.gitmodules" ]; then
    git -C "$dir" submodule foreach --quiet 'printf "  └ %-24s %s\n" "$(basename "$sm_path")" "$(git status -sb | head -1)"'
  fi
}

show "$ROOT" "(workspace)"
for d in "$ROOT"/*/; do
  [ -e "$d.git" ] || continue
  show "${d%/}" "$(basename "$d")"
done

echo ""
if [ "$dirty" = 0 ]; then
  echo "Ingen lokale endringer."
else
  echo "$dirty repo(er) med lokale endringer."
fi
