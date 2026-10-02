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

Kartlagt 2026-09-30 fra README-er, `hugo.toml` og innhold. Sjekk mot kilden ved tvil.

### Nettstedet docs.samt-bu.no

`samt-bu-docs` er hovedrepoet. Det har egen `CLAUDE.md`, som du skal lese ved arbeid der.
Innholdsrepoene under er **Hugo-moduler** (`go.mod` + `content/`): `samt-bu-docs` henter
dem via `[[module.imports]]` i `hugo.toml` og monterer `content/` på stien som står i tabellen.
Modulstiene skrives `github.com/SAMT-X/...` med store bokstaver.

| Repo | Montert på (under `content/`) | Innhold |
|---|---|---|
| `samt-bu-docs` | – (eget innhold) | Nettstedet: `hugo.toml`, egne seksjoner (behov, innsikt, prosjektstyring, om …), Cloudflare-oppsett |
| `hugo-theme-samt-bu` | – | Tema (Docdock/Altinn-basert). **Git-submodule** i `samt-bu-docs/themes/`, ikke Hugo-modul. README er fortsatt Altinns. |
| `team-architecture` | `arkitektur/overordnet-arkitektur` | Overordnet arkitektur, arkitekturstyring |
| `team-semantics` | `arkitektur/informasjonsarkitektur` | Team Semantikk – informasjonsarkitektur (lite innhold foreløpig) |
| `samt-bu-pilot-1` … `-4` | `pilotering/pilot-1` … `-4` | Én modul per pilot (brukerreiser, arkitektur, juss …) |
| `samt-bu-drafts` | `utkast` | Utkast og forslag (use cases, piloter, temaer) |
| `samt-bu-market-engagement` | `ekstern-markedsdialog` | Ekstern markedsdialog |
| `solution-samt-bu-docs` | `prosjektleveranser/loesninger/cms-loesninger/samt-bu-docs` | Dokumentasjon av selve docs-plattformen (brukerveiledning, teknisk, veikart) |

Innholdsmodulene får automatiske commits («Auto: oppdater lastmod i frontmatter [skip ci]»),
så du bør pulle før du endrer noe.

### Øvrige repoer

| Repo | Innhold |
|---|---|
| `samt-bu-files` | Dokumentarkiv (Word/PDF): `drafts/`, `contributions/`, `library/`, `project-files/`. Offentlig repo. Office-filer lenkes via Office Online-mønsteret i brukerens globale CLAUDE.md. |
| `Oppgaver` | Oppgaver på tvers av delprosjekter. Ligger som **GitHub Issues** (64 per 2026-09-30); repoet har bare README. |
| `information-models` | Felles informasjonsmodeller som OWL/SHACL (`models/person/`). Lite aktivt siden 2026-03. |
| `samt-bu-archi-models` | ArchiMate-modeller og målbilder, med Python-skript for generering og reparasjon. **Privat arbeidsmateriale, ikke i docs.** Klones **ikke** her, se merknad under. |
| `kode-archiscripts` | jArchi-skriptbibliotek (ca. 280 `.ajs`-skript, kjerne i `common/`). Flyttet fra `nasjonal-arkitektur` 2026-08-17. |
| `samt-bu-intern` | Internt arbeidsmateriale for kjerneteamet. **Privat.** Bare README foreløpig. |
| `samt-x.github.io` | Enkel landingsside for orgen. Lenker til den gamle adressen `samt-bu.github.io/samt-bu-docs/`, ikke `docs.samt-bu.no`, så den er trolig utdatert. |
| `samt-bu-architecture` | Oppgaverepo for generisk arkitektur og sluttleveransen (rammeverk for datasentrisk tjenesteutvikling), holdt adskilt fra pilotenes oppgaver i `Oppgaver`. Bare **GitHub Issues** (27 per 2026-10-03), ingen commits, så `pull-all` gir feilmelding her til første commit. #13–#27 er fra arkitekturgruppas møte 2026-10-02 og ligger i Project #5 «SAMT-BU rammeverk og generisk arkitektur». #1–#12 er Kjerstis, koblet til Project #8 «Arkitektur»; avklares med henne. |
| `demo-repository` | GitHubs standard demo-repo. Privat og ikke i bruk. |

**Merknad om `samt-bu-archi-models`:** Den eneste klonen ligger i
`S:\app-data\archi\archi-models\samt-bu-archi-models\`, sammen med de andre Archi-prosjektene.
Ikke klon repoet inn i dette workspacet. En kopi ble laget og slettet igjen 2026-09-30.
`pull-all`/`sync-all` dekker ikke denne klonen, så den må pulles for seg.

## Skript i roten

- `pull-all.sh`, `push-all.sh`, `sync-all.sh` (+ `.bat`-innpakninger) – løkker over alle
  undermapper. Foretrekk `sync-all.sh` for toveis synk; den løser aldri konflikter selv.
- `reweight_content.py` – renummererer `weight:` i `_index.*.md` i innholdsmodulene.
  Stiene er hardkodet til `S:/app-data/github/samt-x-repos/...`.

## Arbeidsregler

- Git-kommandoer mot et under-repo: bruk `git -C <repo> ...`, ikke `cd`.
- Endringer i flere repoer: commit og push hvert repo separat.
- Språk: innhold og commit-meldinger på norsk (bokmål), med mindre repoet bruker engelsk.
