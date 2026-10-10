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
| `samt-bu-pilot-1` … `-4` | `pilotering/pilot-1` … `-4` | Én modul per pilot (brukerreiser, arkitektur, juss …). Har også pilotens **oppgaver som issues**, ett repo til ett pilotprosjekt (overgang pågår, se under). |
| `samt-bu-drafts` | `utkast` | Utkast og forslag (use cases, piloter, temaer) |
| `samt-bu-market-engagement` | `ekstern-markedsdialog` | Ekstern markedsdialog |
| `solution-samt-bu-docs` | `prosjektleveranser/loesninger/cms-loesninger/samt-bu-docs` | Dokumentasjon av selve docs-plattformen (brukerveiledning, teknisk, veikart) |

Innholdsmodulene får automatiske commits («Auto: oppdater lastmod i frontmatter [skip ci]»),
så du bør pulle før du endrer noe.

### Øvrige repoer

| Repo | Innhold |
|---|---|
| `samt-bu-files` | Dokumentarkiv (Word/PDF): `drafts/`, `contributions/`, `library/`, `project-files/`. Offentlig repo. Office-filer lenkes via Office Online-mønsteret i brukerens globale CLAUDE.md. |
| `samt-bu-common-tasks` | **Felles oppgaver** på tvers av pilotene, som GitHub Issues; repoet har bare README. Het `Oppgaver` til 2026-10-10 (gamle adresser sendes videre). Overgangen til ett repo per pilot pågår, med spor i #69: Pilot 3 er flyttet til `samt-bu-pilot-3` (Project 4). Pilot 1 (Project 1) og Pilot 2 (Project 2) ligger fortsatt her, og Pilot 4 (Project 3) bruker issues i `samt-bu-docs`. Merk: Project 3 = Pilot 4 og Project 4 = Pilot 3. |
| `information-models` | Felles informasjonsmodeller som OWL/SHACL (`models/person/`). Lite aktivt siden 2026-03. |
| `samt-bu-archi-models` | ArchiMate-modeller og målbilder, med Python-skript for generering og reparasjon. **Privat arbeidsmateriale, ikke i docs.** Klones **ikke** her, se merknad under. |
| `kode-archiscripts` | jArchi-skriptbibliotek (ca. 280 `.ajs`-skript, kjerne i `common/`). Flyttet fra `nasjonal-arkitektur` 2026-08-17. |
| `samt-bu-intern` | Internt arbeidsmateriale for kjerneteamet. **Privat.** Bare README foreløpig. |
| `samt-x.github.io` | Enkel landingsside for orgen. Lenker til den gamle adressen `samt-bu.github.io/samt-bu-docs/`, ikke `docs.samt-bu.no`, så den er trolig utdatert. |
| `samt-bu-architecture` | Oppgaverepo for generisk arkitektur og sluttleveransen (rammeverk for datasentrisk tjenesteutvikling), holdt adskilt fra pilotenes oppgaver. Bare **GitHub Issues**, ingen commits, så `pull-all` gir feilmelding her til første commit. Oversikt i Project 5 «SAMT-BU rammeverk og generisk arkitektur». Issues starter på #13: Kjerstis første oppsett (`#1`–`#12` og Project 8 «Arkitektur») ble slettet 2026-10-05 etter avtale, med spor i #31. Issue-konvensjon foreslått i #32. |
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

## Sesjonsrutiner

Fra 2026-10-05 startes alle sesjoner fra **denne mappen**, også når arbeidet gjelder
`samt-bu-docs`. Claude Codes minne er knyttet til startmappen, så docs-minnet
(sesjon 1–82, trigger-frasene, alle prosjektnotater) lastes **ikke** automatisk herfra.
Det må leses eksplisitt.

| Minne | Sti | Innhold |
|---|---|---|
| Docs-minnet | `C:\Users\Win11_local\.claude\projects\S--app-data-github-samt-x-repos-samt-bu-docs\memory\` | Nettstedet, Archi, caser, målbilder, sesjonshistorikk |
| Workspace-minnet | `C:\Users\Win11_local\.claude\projects\S--app-data-github-samt-x-repos\memory\` (autolastet) | GitHub-orgen, Projects, arbeid på tvers |
| Backup | `S:\app-data\github\erikhag1git-repos\claude-memory\` (`samt-bu-docs\` og `samt-x-repos\`) | Kopi av begge |

Den detaljerte prosedyren står i docs-minnets `session-start-prompts.md`. Følg den,
med tilpasningene under.

### «Start sesjon»

1. Les `C:\Users\Win11_local\.claude\CLAUDE.md`.
2. Les fra docs-minnet: `MEMORY.md`, `critical-notes.md`, `project_neste-sesjon.md`
   og `session-start-prompts.md`.
3. Les veikartet (`solution-samt-bu-docs/content/veikart/`, alle `_index.nb.md`).
4. Kjør `git status -sb` i **alle** under-repoene, ikke bare docs.
5. List åpne issues i `solution-samt-bu-docs` (teknisk backlog for docs) og åpne
   oppgaver i Project 5 (`samt-bu-architecture`).
6. Sjekk at backup er i sync med **begge** minnemappene.
7. Bekreft hvilke filer som er lest, og gi en kort status.

### «Avslutt sesjon»

Som i `session-start-prompts.md`, men:

- **Git:** commit og push i hvert berørte repo, også workspace-repoet.
- **Issues i riktig repo:** docs-plattformen → `solution-samt-bu-docs`, generisk arkitektur →
  `samt-bu-architecture`, piloter → pilotens eget repo (`samt-bu-pilot-N`), felles pilotoppgaver → `samt-bu-common-tasks`. Lukk alltid med en sluttkommentar om
  resultatet. Administrative endringer i repo/Projects får et `chore`-issue som spor, i det
  repoet endringen gjelder (f.eks. `samt-bu-architecture#31`, `samt-bu-common-tasks#69`).
- **Minne:** docs-spesifikt i docs-minnet, GitHub-org og arbeid på tvers i workspace-minnet.
  Sesjonshistorikken (`project_sesjonshistorikk.md` i docs-minnet) er felles og har én nummerering.
- **Backup:** kopier begge minnemappene til `claude-memory`, commit og push.
- **Sesjonslogg:** `save-session-log.py` finner nyeste samtale uansett startmappe og virker herfra.

## Arbeidsregler

- Git-kommandoer mot et under-repo: bruk `git -C <repo> ...`, ikke `cd`.
- Endringer i flere repoer: commit og push hvert repo separat.
- Språk: innhold og commit-meldinger på norsk (bokmål), med mindre repoet bruker engelsk.
