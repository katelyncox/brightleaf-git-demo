# Internal Demo Guide: Git Integration in Posit Workbench

**Audience:** Posit employees. **Prep time:** 10 minutes. **Demo length:** 15–25 minutes.

## What this demo shows

Workbench gives every data scientist a **consistent, secure, server-side Git experience**
in the IDE they prefer. This repo is intentionally trivial, so the audience watches the
**Git workflow** rather than the analysis.

| IDE | Git UI to show | Key differentiator |
|---|---|---|
| RStudio Pro | Git pane plus terminal (Alt+Shift+T) | Azure DevOps delegated credentials (Entra ID SSO; no PAT) |
| Positron Pro | Source Control view; **Workspaces: New Folder from Git** | One IDE for both R and Python |
| VS Code | Built-in SCM plus **Git Graph** extension | Familiar for software-engineering teams |
| JupyterLab | `jupyterlab-git` extension | Notebook-aware diffs (cells, not JSON) |

## Data context (30 seconds)

Brightleaf Coffee Co. is a fictional coffee chain. It has 3 stores and 5 drinks, with daily cups sold
and revenue from January to June 2026 (2,715 rows). It contains one insight: **Cold Brew rises from
last place to first as the weather warms.** That's all you need to know.

## Pre-demo checklist

- [ ] Repo: https://github.com/katelyncox/brightleaf-git-demo (fork it, or push your own copy if you need write access during the demo)
- [ ] Log in to a Workbench server where each IDE you plan to show is enabled
- [ ] Confirm `gh` (GitHub CLI) is installed on the Workbench server for the OAuth sign-in (`gh --version`)
- [ ] Sign in with `gh auth login` / `gh auth setup-git` (or add an SSH key or PAT) in each session, or plan to do it live (see GIT-DEMO.md §0)
- [ ] Set `git config --global user.name/user.email`
- [ ] Confirm that JupyterLab has `jupyterlab-git`, and that VS Code has Git Graph (or plan to install it live)
- [ ] For Azure DevOps delegated credentials: confirm the server has Entra ID SSO and delegated permissions configured, and have an ADO repo ready
- [ ] Run `renv::restore()` and `uv sync` once beforehand to warm up the package cache
- [ ] Delete any old clones so the "clone" step is fresh

## Demo script

1. **Frame it (1 min):** "Workbench sessions run on the server. Your code, credentials, and Git
   all live there, next to your data and compute, in whatever IDE you like."
2. **Credentials (3 min):** Lead with **OAuth**: run `gh auth login --web` in a Workbench terminal,
   approve the device code on your laptop, then run `gh auth setup-git`. There are no keys or tokens to copy.
   Briefly mention SSH keys and PATs as alternatives, plus the `credential.helper` tip for ephemeral storage.
3. **RStudio Pro (4 min):** New Project from Git → edit `eda.qmd` → Render → Git pane →
   stage, commit, and push. Point out that the CSV and HTML aren't tracked.
4. **Positron Pro (3 min):** Command Palette → *Workspaces: New Folder from Git* → edit →
   Source Control → commit → Sync.
5. **JupyterLab (3 min):** Clone from the Git panel → edit the notebook → **show the notebook diff**
   (this usually gets the biggest reaction from Python users).
6. **VS Code (2 min):** Show Git Graph's history of the commits you just made from the other IDEs.
7. **Team moment (2 min):** Change `primary` in `_brand.yml` in one IDE, push, pull in another IDE,
   and re-render.
8. **Azure DevOps (optional, RStudio Pro only):** `git clone https://dev.azure.com/...` with
   **no credential prompt**. This is a strong point for Microsoft-heavy enterprises.

## Talking points

- **Choice without chaos:** four IDEs, one Git server, the same repo.
- **Security:** credentials live in the user's Workbench home directory, not on laptops. With ADO
  delegated credentials, there are no long-lived tokens at all.
- **Reproducibility:** `renv.lock` and `uv.lock` are committed, so anyone who clones gets the same packages
  (and Posit Package Manager makes the restore fast).
- **Good hygiene by default:** `.gitignore` keeps data, rendered output, and credentials out of the repo.

## Troubleshooting

See the table at the bottom of [GIT-DEMO.md](GIT-DEMO.md). The most common live failures:
- **Wrong URL type:** OAuth and PATs need the `https://` URL; SSH keys need `git@...`.
- **OAuth sign-in succeeded but Git still prompts:** run `gh auth setup-git`.
- **Missing Git pane in RStudio:** the user didn't open the `.Rproj` file.
- **Data missing:** run `Rscript data/generate_data.R` (the docs also generate it automatically).

## Next steps / call to action

- Offer a hands-on Workbench trial, using this repo as the first exercise.
- For Azure DevOps shops, connect them with Solutions Engineering to configure Entra ID delegated credentials.
- Discuss pairing Git with **Posit Connect** (git-backed deployment) and **Package Manager**.
