# CLAUDE.md – samt-x-workspace

Instruksjoner for Claude Code på tvers av alle repoer i GitHub-organisasjonen `samt-x`.
Denne filen lastes også når Claude startes fra en undermappe (f.eks. `samt-bu-docs/`),
i tillegg til det aktuelle repoets egen `CLAUDE.md`.

## Hva er dette?

Et workspace-repo som ligger i roten av `S:\app-data\github\samt-x-repos\`.
Under-repoene er **selvstendige git-repoer** klonet som undermapper, og er ignorert
av dette repoets `.gitignore` (whitelist). Commit aldri innhold fra under-repoene her.

Prosjektet er **SAMT-BU** (Sammenhengende tjenester for barn og unge). Hovedkanalen
er dokumentasjonsnettstedet `https://docs.samt-bu.no/` (Hugo, Cloudflare Pages),
bygget fra `samt-bu-docs` med flere innholdsrepoer montert som Hugo-moduler.

## Repoer

| Repo | Rolle |
|---|---|
| `samt-bu-docs` | Hovednettstedet (Hugo). Har egen `CLAUDE.md` – les den ved arbeid der. |
| `hugo-theme-samt-bu` | Hugo-tema (basert på Docdock/Altinn), submodule i `samt-bu-docs` |
| `samt-bu-drafts` | Hugo-modul: innspill |
| `team-architecture` | Hugo-modul: arkitektur |
| `team-semantics` | Hugo-modul: Team Semantikk |
| `samt-bu-market-engagement` | Hugo-modul: ekstern markedsdialog |
| `samt-bu-pilot-1` … `-4` | Hugo-moduler: pilotene |
| `solution-samt-bu-docs` | Teknisk dokumentasjon/løsningsbeskrivelse for docs-plattformen |
| `samt-bu-files` | Filer (dokumenter o.l.) som lenkes fra nettstedet |
| `Oppgaver` | Oppgaver på tvers av delprosjekter |
| `samt-x.github.io` | GitHub Pages for organisasjonen |
| `demo-repository` | GitHubs demo-repo (privat, ikke i bruk) |

Finnes i orgen men er ikke klonet lokalt per 2026-09-30: `samt-bu-archi-models` (privat),
`samt-bu-intern` (privat), `samt-bu-architecture`, `kode-archiscripts`, `information-models`.

## Skript i roten

- `pull-all.sh`, `push-all.sh`, `sync-all.sh` (+ `.bat`-innpakninger) – løkker over alle
  undermapper. Foretrekk `sync-all.sh` for toveis synk; den løser aldri konflikter selv.
- `reweight_content.py` – renummererer `weight:` i `_index.*.md` i innholdsmodulene.
  Stiene er hardkodet til `S:/app-data/github/samt-x-repos/...`.

## Arbeidsregler

- Git-kommandoer mot et under-repo: bruk `git -C <repo> ...`, ikke `cd`.
- Endringer i flere repoer: commit og push hvert repo separat.
- Språk: innhold og commit-meldinger på norsk (bokmål), med mindre repoet bruker engelsk.
