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
| `samt-bu-pilot-1` … `-6` | `pilotering/pilot-1` … `-6` | Én modul per pilot (brukerreiser, arkitektur, juss …). Pilot 5 (Id-er i utdanning, Sikt) og Pilot 6 (Foreldres tilgang til data) opprettet 2026-10-10, spor i `samt-bu-common-tasks#70`. Har også pilotens **oppgaver som issues**, ett repo til ett pilotprosjekt (se `samt-bu-common-tasks` under). |
| `samt-bu-drafts` | `utkast` | Utkast og forslag (use cases, piloter, temaer) |
| `samt-bu-market-engagement` | `ekstern-markedsdialog` | Ekstern markedsdialog |
| `solution-samt-bu-docs` | `prosjektleveranser/loesninger/samhandlingsplattform/samt-bu-docs` | Dokumentasjon av selve docs-plattformen (brukerveiledning, teknisk, veikart) |
| `solution-task-management` | `prosjektleveranser/loesninger/samhandlingsplattform/oppgavestyring` | Oppgavestyring som egen løsning (repo↔Project, konvensjoner, API-fallgruver), opprettet 2026-10-10. Har også **issues for oppgavestyringen**, blant annet de tidligere `samt-bu-architecture` nr. 28 og 32 (nå #1 og #2, fortsatt i Project 5). Kategorien «Samhandlingsplattform» (med siden Introduksjon, som også dekker valget av git-plattform) er lokal i `samt-bu-docs`. Den erstattet «CMS-løsninger» og «Styringsløsninger» 2026-10-11. |

Innholdsmodulene får automatiske commits («Auto: oppdater lastmod i frontmatter [skip ci]»),
så du bør pulle før du endrer noe.

### Øvrige repoer

| Repo | Innhold |
|---|---|
| `samt-bu-files` | Dokumentarkiv (Word/PDF): `drafts/`, `contributions/`, `library/`, `project-files/`. Offentlig repo. Office-filer lenkes via Office Online-mønsteret i brukerens globale CLAUDE.md. |
| `samt-bu-common-tasks` | **Felles oppgaver** på tvers av pilotene, som GitHub Issues; repoet har bare README. Het `Oppgaver` til 2026-10-10 (gamle adresser sendes videre). Overgangen til ett repo per pilot er gjennomført, med spor i #69: Pilot 1, 2 og 3 er flyttet til `samt-bu-pilot-1` (Project 1), `samt-bu-pilot-2` (Project 2) og `samt-bu-pilot-3` (Project 4), og Pilot 4 til `samt-bu-pilot-4` (Project 3). Unntak: to sidekommentarer fra docs-nettstedet (`samt-bu-docs` nr. 97 og 98) står i Project 3, men må ligge i `samt-bu-docs` for at kommentarpanelet på siden skal finne dem. Pilot 5 og 6 har Project 9 og 10. Merk: Project 3 = Pilot 4 og Project 4 = Pilot 3. |
| `information-models` | Felles informasjonsmodeller som OWL/SHACL (`models/person/`). Filene er lite endret siden 2026-03, men oppgavene (issues) er aktive. |
| `samt-bu-archi-models` | ArchiMate-modeller og målbilder, med Python-skript for generering og reparasjon. **Privat arbeidsmateriale, ikke i docs.** `samt-bu-alle` har Read (fra 2026-10-23), så prosjektdeltakerne kan lese den. Skrivetilgang via teamet `samt-bu-archimate` (Morten, Cat, Erik), som også har Write på `kode-archiscripts`. Klones **ikke** her, se merknad under. |
| `kode-archiscripts` | jArchi-skriptbibliotek (ca. 280 `.ajs`-skript, kjerne i `common/`). Flyttet fra `nasjonal-arkitektur` 2026-08-17. |
| `samt-bu-intern-admin` | Internt arbeidsmateriale og administrasjon for kjerneteamet (medlemsoversikt m.m.). **Privat:** bare `samt-bu-core-team` og eierne, fordi grunnrettigheten for orgen er «No permission» fra 2026-10-23 (`solution-samt-bu-docs#72`). Het `samt-bu-intern` til 2026-10-23. |
| `samt-x.github.io` | Enkel landingsside for orgen. Lenker til den gamle adressen `samt-bu.github.io/samt-bu-docs/`, ikke `docs.samt-bu.no`, så den er trolig utdatert. |
| `samt-bu-architecture` | Oppgaverepo for generisk arkitektur og sluttleveransen (rammeverk for datasentrisk tjenesteutvikling), holdt adskilt fra pilotenes oppgaver. Bare **GitHub Issues**, ingen commits, så `pull-all` gir feilmelding her til første commit. Oversikt i Project 5 «SAMT-BU rammeverk og generisk arkitektur». Issues starter på #13: Kjerstis første oppsett (`#1`–`#12` og Project 8 «Arkitektur») ble slettet 2026-10-05 etter avtale, med spor i #31. Issue-konvensjon foreslått i #32. |
| `samt-bu-portfolio` | Porteføljekort: ett issue per pilot, produkt og arbeidsområde, på Project 13 «SAMT-BU Overview – Portfolio» (Status = fase, Category, Owner, Health, Target date). Opprettet 2026-10-19 (B1, `solution-task-management#10`). Holdes utenfor samlebrettet Project 12 «SAMT-BU Overview – All tasks», som fylles hver time av Action i `solution-task-management`. |
| ~~`demo-repository`~~ | Slettet 2026-10-23. Var GitHubs standard demo-repo fra oppsettet av orgen (Kjersti, 2026-02-06), aldri i bruk. |

**Merknad om `samt-bu-archi-models`:** Den eneste klonen ligger i
`S:\app-data\archi\archi-models\samt-bu-archi-models\`, sammen med de andre Archi-prosjektene.
Ikke klon repoet inn i dette workspacet. En kopi ble laget og slettet igjen 2026-09-30.
`pull-all`/`sync-all` dekker ikke denne klonen, så den må pulles for seg.

## Skript i roten

- `pull-all.sh`, `push-all.sh`, `sync-all.sh` (+ `.bat`-innpakninger) – løkker over alle
  undermapper. Foretrekk `sync-all.sh` for toveis synk; den løser aldri konflikter selv.
- `status-all.sh` (+ `.bat`) – én statuslinje per repo, endrede filer under, endrer ingenting. `--fetch` henter først.
  Laget 2026-10-24 for at Claude skal slippe løkker over stier, som gir stopp for tillatelse.
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
4. Kjør `bash S:/app-data/github/samt-x-repos/status-all.sh --fetch`. Det viser status for **alle** repoene,
   også temaet som submodule.
5. List åpne issues i `solution-samt-bu-docs` (teknisk backlog for docs) og åpne
   oppgaver i Project 5 (`samt-bu-architecture`).
6. Sjekk at backup er i sync med **begge** minnemappene.
   Sjekk også utløpet for `gh`-tokenen (`gh api -i rate_limit`, headeren `github-authentication-token-expiration`).
   Varsle Erik hvis det er under 30 dager igjen. Er headeren borte, er en token uten utløp i bruk – si fra.
   Sjekk også datoen for Actions-secreten `BUILD_REPORT_TOKEN` i `samt-bu-docs` (fine-grained PAT på `samt-x-bot`,
   Issues read/write på `solution-samt-bu-docs`, i Bitwarden). Den **utløper 2027-10-25**, og utløpet kan ikke leses
   fra API-et. Varsle Erik under 30 dager før. Ny token: oppdater datoen her.
7. Sjekk innloggingen i Chrome-profilen «Claude», hvis utvidelsen er koblet til: åpne en fane med github.com og en med
   docs.samt-bu.no, og se om Erik er innlogget. Er han ikke det, la fanene stå på innloggingen: `github.com/login`, og på
   docs-siden «Endre» → logg inn (popupen kan havne utenfor fanegruppen). Ta GitHub først, så går docs-innloggingen
   uten passord. Erik skriver passordet selv, aldri Claude. Er utvidelsen ikke koblet til, nevn det kort og gå videre.
8. Bekreft hvilke filer som er lest, og gi en kort status.
9. Avslutt med **Claude-hint** (under), kort og uendret, som påminnelse til Erik.

### Claude-hint (vises ved «Start sesjon»)

| Hva | Hvordan |
|---|---|
| Fortsette forrige samtale | `claude --continue` fra denne mappen · velg fra liste: `claude --resume` |
| Bytte modus (auto, plan, …) | **Shift+Tab** – modusen står nederst. `defaultMode` er `auto` |
| Tunge skriptdager | `claude --continue --allowedTools "Bash(python:*)"` (gjelder bare den sesjonen) |
| Svar på tillatelsesspørsmål | Velg **«Yes»**, ikke «don't ask again» – det lagrer en varig regel |
| Kjøre en kommando selv | `! <kommando>` – kjører i **Bash**, ikke PowerShell |
| Gi Claude en mappe til | `/add-dir <sti>` (f.eks. NGI Zero, bare ved behov) |
| Navngi sesjonen | `/rename <navn>` |
| Admin-sesjon i GitHub | Eget vindu: `$env:GH_TOKEN = "<admin fra Bitwarden>"; claude --continue` |
| Nettleser for Claude | Bare Chrome-profilen **«Claude»** (fersken). Logg inn per oppgave, ut etterpå. Ikke koblet? Klikk stjernen → sjekk innlogging i sidepanelet |

### «Avslutt sesjon»

Som i `session-start-prompts.md`, men:

- **Git:** commit og push i hvert berørte repo, også workspace-repoet.
- **Issues i riktig repo:** docs-plattformen → `solution-samt-bu-docs`, oppgavestyringen → `solution-task-management`, generisk arkitektur →
  `samt-bu-architecture`, piloter → pilotens eget repo (`samt-bu-pilot-N`), felles pilotoppgaver → `samt-bu-common-tasks`. Lukk alltid med en sluttkommentar om
  resultatet. Administrative endringer i repo/Projects får et `chore`-issue som spor, i det
  repoet endringen gjelder (f.eks. `samt-bu-architecture#31`, `samt-bu-common-tasks#69`).
- **Minne:** docs-spesifikt i docs-minnet, GitHub-org og arbeid på tvers i workspace-minnet.
  Sesjonshistorikken (`project_sesjonshistorikk.md` i docs-minnet) er felles og har én nummerering.
- **Backup:** kopier begge minnemappene til `claude-memory`, commit og push.
- **Sesjonslogg:** `save-session-log.py` finner nyeste samtale uansett startmappe og virker herfra.
- **Skjermbilder:** kopier bildene Erik har limt inn fra sesjonens midlertidige mappe
  (`%TEMP%\claude\<prosjektmappe>\<sesjons-id>\images\`, stien står i bildemeldingene) til
  `S:\app-data\claude\session-images\s<N>\`, med samme nummer som sesjonsloggen. Temp-mappen kan tømmes av
  Windows, og Claude Code sletter samtalefilene (`.jsonl`) etter 30 dager. Bildene legges **ikke** i `claude-memory`,
  fordi de kan vise innstillinger. Ved prematur avslutning: kopier på nytt ved ekte slutt (overskriver).
- **Utlogging i Chrome-profilen «Claude»:** Minn Erik på det, og tilby å gjøre det selv: først docs.samt-bu.no (avataren →
  «Logg ut», sletter bare tokenen lokalt), så github.com (avataren → «Sign out» → bekreft). Spør med AskUserQuestion, ett ja/nei-spørsmål per sted, og logg bare ut der Erik svarer ja. Er utvidelsen ikke koblet
  til, eller er profilen ikke brukt i sesjonen, holder det med påminnelsen. Begrunnelse: en innlogget nettleser har alle
  rettighetene til kontoen, mens `gh`-tokenen er strammet inn (sesjon 92).
- **Navn på sesjonen:** Velg selv et kort navn som sier hva som er gjort (f.eks. `s92 Tilganger og org-opprydding`),
  uten å spørre Erik. Bruk det i sesjonshistorikken, og vis linjen `/rename <navn>` til slutt i avslutningen, ferdig til
  å lime inn. Claude kan ikke kjøre slash-kommandoer selv. Har Erik allerede gitt sesjonen et navn, bruk det.

## Arbeidsregler

- Git-kommandoer mot et under-repo: bruk `git -C <repo> ...`, ikke `cd`.
- Endringer i flere repoer: commit og push hvert repo separat.
- Språk: innhold og commit-meldinger på norsk (bokmål), med mindre repoet bruker engelsk.
