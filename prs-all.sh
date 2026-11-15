#!/usr/bin/env bash
# prs-all.sh – åpne pull requests i ALLE repoene i samt-x (også de som ikke er klonet her).
# Viser forfatter, dato, utkast, eieren fra .github/CODEOWNERS (fra 2026-11-15, solution-task-management#46)
# og hvem som er bedt om review. Endrer ingenting.
# Spør GraphQL direkte, fordi «gh search prs» bygger på en søkeindeks som kan ligge etter.
# Laget 2026-11-03 (s111). Kjøres ved «Start sesjon».

gh api graphql -f query='
query {
  organization(login: "samt-x") {
    repositories(first: 100) {
      totalCount
      nodes {
        name
        codeowners: object(expression: "HEAD:.github/CODEOWNERS") { ... on Blob { text } }
        pullRequests(states: OPEN, first: 50) {
          nodes {
            number title url isDraft createdAt
            author { login }
            reviewRequests(first: 10) {
              nodes { requestedReviewer { ... on User { login } ... on Team { slug } } }
            }
          }
        }
      }
    }
  }
}' --jq '
.data.organization.repositories as $r
| [$r.nodes[] | .name as $n
   | ((.codeowners.text // "") | split("\n") | map(select(startswith("*"))) | (.[0] // "* mangler") | sub("^\\*\\s*"; "")) as $o
   | .pullRequests.nodes[] | {repo: $n, owner: $o, pr: .}] as $prs
| "Åpne pull requests i samt-x: \($prs | length) (\($r.totalCount) repoer sjekket)",
  ($prs[] |
    "\(.repo)#\(.pr.number)  \(.pr.title)",
    "    av \(.pr.author.login // "ukjent"), opprettet \(.pr.createdAt[:10])\(if .pr.isDraft then ", utkast" else "" end)",
    "    eier (CODEOWNERS): \(.owner)",
    "    review bedt fra: \([.pr.reviewRequests.nodes[].requestedReviewer | .login // .slug] | if length == 0 then "ingen" else join(", ") end)",
    "    \(.pr.url)")'
