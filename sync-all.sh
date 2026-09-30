#!/usr/bin/env bash
# Synkroniserer alle git-repoer under denne mappen med GitHub.
#
# Strategi per repo:
#   1. Stash ucommittede endringer midlertidig (gjenopprettes etterpå)
#   2. Hent remote-status (git fetch)
#   3. Kun remote foran  → git pull (fast-forward)
#      Kun lokal foran   → git push
#      Begge divergert   → git pull --rebase (automatisk merge av ikke-overlappende endringer)
#                          Konflikt → STOPP og rapporter hvilke filer – ingen data tapes
#
# NB: Skriptet løser ALDRI konflikter automatisk på vegne av deg.
#     Rebase er valgt fremfor merge for å unngå unødvendige merge-commits.
#
# Kjør fra S:\app-data\github\samt-x-repos\ eller med full sti.

ROOT="$(cd "$(dirname "$0")" && pwd)"
FEIL=0

for d in "$ROOT"/*/; do
  [ -d "$d/.git" ] || continue
  name=$(basename "$d")
  echo "=== $name ==="

  # Sjekk om det finnes en upstream-branch
  if ! git -C "$d" rev-parse --abbrev-ref --symbolic-full-name '@{u}' &>/dev/null; then
    echo "  Ingen upstream konfigurert – hopper over"
    echo ""
    continue
  fi

  # Stash ucommittede endringer hvis det finnes noe
  STASHED=0
  if ! git -C "$d" diff --quiet || ! git -C "$d" diff --cached --quiet; then
    echo "  Midlertidig stasher ucommittede endringer..."
    git -C "$d" stash push --include-untracked -m "sync-all auto-stash" &>/dev/null
    STASHED=1
  fi

  # Hent remote-info
  git -C "$d" fetch origin --quiet

  LOCAL=$(git -C "$d" rev-parse HEAD)
  REMOTE=$(git -C "$d" rev-parse '@{u}')
  BASE=$(git -C "$d" merge-base HEAD '@{u}')

  if [ "$LOCAL" = "$REMOTE" ]; then
    echo "  Allerede synkronisert"

  elif [ "$LOCAL" = "$BASE" ]; then
    # Remote er foran – hent
    BEHIND=$(git -C "$d" rev-list --count 'HEAD..@{u}')
    echo "  Henter $BEHIND commit(s) fra remote..."
    git -C "$d" pull --ff-only
    if [ $? -ne 0 ]; then
      echo "  FEIL: Kunne ikke fast-forward – prøv manuelt"
      FEIL=1
    fi

  elif [ "$REMOTE" = "$BASE" ]; then
    # Lokal er foran – push
    AHEAD=$(git -C "$d" rev-list --count '@{u}..HEAD')
    echo "  Pusher $AHEAD lokal(e) commit(s)..."
    git -C "$d" push
    if [ $? -ne 0 ]; then
      echo "  FEIL: Push mislyktes"
      FEIL=1
    fi

  else
    # Begge har nye commits – rebase lokale oppå remote
    AHEAD=$(git -C "$d" rev-list --count '@{u}..HEAD')
    BEHIND=$(git -C "$d" rev-list --count 'HEAD..@{u}')
    echo "  Divergert: $AHEAD lokal(e) / $BEHIND remote commit(s)"
    echo "  Forsøker rebase (legger dine commits oppå remote)..."

    REBASE_OUTPUT=$(git -C "$d" pull --rebase 2>&1)
    REBASE_STATUS=$?

    if [ $REBASE_STATUS -eq 0 ]; then
      echo "  Rebase OK – pusher..."
      git -C "$d" push
      if [ $? -ne 0 ]; then
        echo "  FEIL: Push etter rebase mislyktes"
        FEIL=1
      fi
    else
      # Rebase feilet – avbryt og rapporter nøyaktig hva som konfliktet
      echo ""
      echo "  *** KONFLIKT i $name ***"
      echo "  Git klarte ikke å slå sammen endringene automatisk."
      echo "  Rebase er avbrutt – ingen av dine filer er endret."
      echo ""

      # Finn konfliktfilene fra rebase-output
      CONFLICT_FILES=$(echo "$REBASE_OUTPUT" | grep -E "^CONFLICT|Merge conflict" | sed 's/CONFLICT ([^)]*): //')
      if [ -n "$CONFLICT_FILES" ]; then
        echo "  Konfliktfiler:"
        echo "$CONFLICT_FILES" | while read -r f; do echo "    $f"; done
        echo ""
      fi

      # Spesialtilfelle: go.mod / go.sum (Hugo-modulkonflikter)
      if echo "$CONFLICT_FILES" | grep -qE "go\.(mod|sum)"; then
        echo "  TIPS (go.mod/go.sum): Disse er tekniske låsfiler."
        echo "  Løsning etter manuell rebase:"
        echo "    cd \"$d\""
        echo "    git pull --rebase"
        echo "    # ved konflikt i go.mod/go.sum:"
        echo "    git checkout --theirs go.mod go.sum"
        echo "    hugo mod tidy"
        echo "    git add go.mod go.sum && git rebase --continue"
        echo ""
      fi

      echo "  Slik løser du konflikten manuelt:"
      echo "    cd \"$d\""
      echo "    git pull --rebase"
      echo "    # Rediger konfliktfilene (søk etter <<<<<< i filene)"
      echo "    # For å se hva som er forskjellig:"
      echo "    #   git diff"
      echo "    # Etter at du har valgt hva som skal beholdes:"
      echo "    git add <fil>"
      echo "    git rebase --continue"
      echo "    git push"
      echo ""

      git -C "$d" rebase --abort
      FEIL=1
    fi
  fi

  # Gjenopprett stash
  if [ "$STASHED" -eq 1 ]; then
    echo "  Gjenoppretter stashede endringer..."
    git -C "$d" stash pop
    if [ $? -ne 0 ]; then
      echo "  ADVARSEL: Stash pop fikk konflikter – kjør 'git stash show -p' i $name"
      FEIL=1
    fi
  fi

  # Oppdater submoduler
  if [ -f "$d/.gitmodules" ]; then
    echo "  Oppdaterer submoduler..."
    git -C "$d" submodule update --recursive
  fi

  echo ""
done

if [ "$FEIL" -ne 0 ]; then
  echo "Ferdig – ett eller flere repoer trenger manuell behandling (se over)."
  exit 1
else
  echo "Ferdig – alle repoer synkronisert."
fi
