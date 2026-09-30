#!/usr/bin/env bash
# Pusher alle git-repoer under denne mappen som har upushede commits.
# Hopper over repoer med ucommittede endringer (varsler i stedet).
# Kjør fra S:\app-data\github\samt-x-repos\ eller med full sti.

ROOT="$(cd "$(dirname "$0")" && pwd)"
FEIL=0

for d in "$ROOT"/*/; do
  [ -d "$d/.git" ] || continue
  name=$(basename "$d")
  echo "=== $name ==="

  # Sjekk ucommittede endringer
  if ! git -C "$d" diff --quiet || ! git -C "$d" diff --cached --quiet; then
    echo "  ADVARSEL: Ucommittede endringer – hopper over push"
    echo ""
    FEIL=1
    continue
  fi

  # Sjekk om det finnes en upstream-branch
  if ! git -C "$d" rev-parse --abbrev-ref --symbolic-full-name '@{u}' &>/dev/null; then
    echo "  Ingen upstream konfigurert – hopper over"
    echo ""
    continue
  fi

  # Tell commits foran remote
  AHEAD=$(git -C "$d" rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)

  if [ "$AHEAD" -eq 0 ]; then
    echo "  Allerede oppdatert – ingenting å pushe"
  else
    echo "  Pusher $AHEAD commit(s)..."
    if git -C "$d" push; then
      echo "  OK"
    else
      echo "  FEIL: Push mislyktes"
      FEIL=1
    fi
  fi

  echo ""
done

if [ "$FEIL" -ne 0 ]; then
  echo "Ferdig – men ett eller flere repoer hadde problemer (se over)."
else
  echo "Ferdig."
fi
