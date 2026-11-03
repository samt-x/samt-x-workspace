#!/usr/bin/env bash
# Kontoer utenfor orgen som har bidratt i et offentlig samt-x-repo (PR, issue, kommentar, review).
# Selve skriptet ligger i solution-task-management, så workflowen Sync All tasks kan kjøre det hver time
# og holde issuet «Bidragsytere utenfor orgen (N)» oppdatert. Her skrives bare lista ut. Endrer ingenting.
# Laget 2026-11-03 (s113, solution-task-management#49). Kjøres ved «Start sesjon».
#
#   bash S:/app-data/github/samt-x-repos/outside-contributors.sh
#
# Fast skript med fast sti, så Claude Code slipper å spørre (se status-all.sh).

ROOT="$(cd "$(dirname "$0")" && pwd)"
exec python "$ROOT/solution-task-management/.github/scripts/outside-contributors.py" "$@"
