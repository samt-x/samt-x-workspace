# samt-x-workspace

Arbeidsområde for lokal utvikling på tvers av alle repoer i GitHub-organisasjonen [samt-x](https://github.com/samt-x).

Repoet inneholder **ikke** de andre repoene – bare felles skript og Claude Code-instruksjoner. De enkelte repoene klones som undermapper og ignoreres av `.gitignore`.

## Oppsett

```bash
git clone https://github.com/samt-x/samt-x-workspace.git samt-x-repos
cd samt-x-repos
git clone https://github.com/samt-x/samt-bu-docs.git
# ... klon øvrige repoer du trenger (se CLAUDE.md for oversikt)
```

## Skript

| Skript | Hva det gjør |
|---|---|
| `pull-all.sh` / `.bat` | `git pull` i alle under-repoer (+ submoduler) |
| `push-all.sh` / `.bat` | Pusher upushede commits; hopper over repoer med ucommittede endringer |
| `sync-all.sh` / `.bat` | Full toveis synk: pull/push/rebase per repo, stopper ved konflikt |
| `reweight_content.py` | Renummererer Hugo `weight:` til 10, 20, 30 … i innholdsmodulene |
| `start-session-samt-bu-docs.bat` | Starter Hugo-server og Claude Code i `samt-bu-docs` |

`.bat`-filene er innpakninger som kjører tilsvarende `.sh` via Git Bash.
