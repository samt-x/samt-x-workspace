#!/usr/bin/env bash
# Sider der norsk og engelsk ikke er i takt, i begge retninger, i alle innholdsrepoene her.
# Selve skriptet ligger i samt-bu-docs, så GitHub-workflowen translations.yml kan kjøre det.
# Se forklaringen øverst der. Endrer ingenting.
#
#   bash S:/app-data/github/samt-x-repos/check-translations.sh                 # oversikt
#   bash S:/app-data/github/samt-x-repos/check-translations.sh --diff          # + endringene som må oversettes
#   bash S:/app-data/github/samt-x-repos/check-translations.sh --repo <navn>   # bare ett repo (kan kombineres)
#
# Fast skript med fast sti, så Claude Code slipper å spørre (se status-all.sh).

ROOT="$(cd "$(dirname "$0")" && pwd)"
exec bash "$ROOT/samt-bu-docs/.github/scripts/check-translations.sh" --root "$ROOT" "$@"
