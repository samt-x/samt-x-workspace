#!/usr/bin/env bash
# Finner engelske sider som mangler eller ligger bak den norske, i alle innholdsrepoene
# (repoer med content/). Endrer ingenting.
#
#   bash S:/app-data/github/samt-x-repos/check-translations.sh                 # oversikt
#   bash S:/app-data/github/samt-x-repos/check-translations.sh --diff          # + norske endringer siden siste en-commit
#   bash S:/app-data/github/samt-x-repos/check-translations.sh --repo <navn>   # bare ett repo (kan kombineres)
#
# Tre grupper:
#   MANGLER      *.nb.md finnes, *.en.md finnes ikke
#   PLASSHOLDER  *.en.md har «English translation TBD»
#   BAK          norsk er endret (av et menneske) etter siste menneskelige commit på engelsk
#   STRUKTUR     ulikt antall overskrifter, eller engelsk brødtekst under 60 % av norsk lengde.
#                Fanger det BAK ikke ser: en commit som rørte begge filene (lenkeretting, omdøping)
#                uten at engelsk ble oversatt, får engelsk til å se oppdatert ut.
#
# Bot-commits telles ikke: «Auto: oppdater lastmod» og uuid-commitene rører begge filene
# og ville ellers fått engelsk til å se oppdatert ut. Rene formendringer på norsk
# (skrivefeil, weight) gir også treff i BAK – --diff viser om noe må oversettes.
#
# Fast skript med fast sti, så Claude Code slipper å spørre (se status-all.sh).

ROOT="$(cd "$(dirname "$0")" && pwd)"
DIFF=0
ONLY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --diff) DIFF=1 ;;
    --repo) ONLY="$2"; shift ;;
  esac
  shift
done

# Siste commit på filen som ikke er laget av en bot
last_human() {
  git -C "$1" log --format='%H|%ae|%aN' -- "$2" 2>/dev/null \
    | grep -v '\[bot\]' | head -1 | cut -d'|' -f1
}

# Brødteksten uten frontmatter
body() {
  awk 'n >= 2; /^---[[:space:]]*$/ { n++ }' "$1"
}

n_missing=0; n_tbd=0; n_behind=0; n_struct=0
missing=""; tbd=""; behind=""; struct=""

for d in "$ROOT"/*/; do
  repo="$(basename "$d")"
  [ -e "$d.git" ] && [ -d "${d}content" ] || continue
  [ -n "$ONLY" ] && [ "$repo" != "$ONLY" ] && continue
  dir="${d%/}"

  while IFS= read -r nb; do
    rel="${nb#$dir/}"
    en_rel="${rel%.nb.md}.en.md"
    if [ ! -f "$dir/$en_rel" ]; then
      missing+="  $repo/$rel"$'\n'; n_missing=$((n_missing + 1))
      continue
    fi
    if grep -qiE 'translation TBD|TODO english translation' "$dir/$en_rel"; then
      tbd+="  $repo/$en_rel"$'\n'; n_tbd=$((n_tbd + 1))
      continue
    fi
    # Struktur: ulikt antall overskrifter, eller engelsk under 60 % av norsk lengde
    nb_h=$(body "$nb" | grep -cE '^#{1,6} ')
    en_h=$(body "$dir/$en_rel" | grep -cE '^#{1,6} ')
    nb_c=$(body "$nb" | wc -c)
    en_c=$(body "$dir/$en_rel" | wc -c)
    if [ "$nb_h" != "$en_h" ] || { [ "$nb_c" -gt 300 ] && [ $((en_c * 100)) -lt $((nb_c * 60)) ]; }; then
      struct+="  $repo/$en_rel  (overskrifter nb $nb_h / en $en_h, tegn nb $nb_c / en $en_c)"$'\n'
      n_struct=$((n_struct + 1))
    fi
    en_commit=$(last_human "$dir" "$en_rel")
    [ -z "$en_commit" ] && continue
    count=$(git -C "$dir" log --format='%ae|%aN' "$en_commit..HEAD" -- "$rel" | grep -vc '\[bot\]')
    if [ "$count" -gt 0 ]; then
      nb_date=$(git -C "$dir" log --format='%ae|%cs' "$en_commit..HEAD" -- "$rel" | grep -v '\[bot\]' | head -1 | cut -d'|' -f2)
      en_date=$(git -C "$dir" log -1 --format='%cs' "$en_commit")
      behind+="  $repo/$rel  ($count commit(er), nb $nb_date, en $en_date)"$'\n'
      if [ "$DIFF" = 1 ]; then
        behind+="$(git -C "$dir" diff --no-color "$en_commit..HEAD" -- "$rel" | grep -E '^[-+]' | grep -vE '^(\+\+\+|---)|^[-+](lastmod|last_editor|weight|id):' | sed 's/^/      /')"$'\n'
      fi
      n_behind=$((n_behind + 1))
    fi
  done < <(find "$dir/content" -name '*.nb.md' | sort)
done

echo "== MANGLER engelsk ($n_missing)"
printf "%s" "$missing"
echo ""
echo "== PLASSHOLDER «English translation TBD» ($n_tbd)"
printf "%s" "$tbd"
echo ""
echo "== BAK: norsk endret etter siste engelske ($n_behind)"
printf "%s" "$behind"
echo ""
echo "== STRUKTUR: ulikt antall overskrifter eller engelsk under 60 % av norsk ($n_struct)"
printf "%s" "$struct"
echo ""
echo "Sum: $n_missing mangler, $n_tbd plassholder, $n_behind bak, $n_struct struktur."
