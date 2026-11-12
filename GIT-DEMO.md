# Git in Posit Workbench — Hands-On Walkthrough

This walkthrough uses this repository to show Git integration in each Posit Workbench IDE.
Every IDE section follows the same loop:

> **Clone → Edit → Stage → Commit → Push → (Pull)**

Pick the IDEs that matter to your audience. Each section takes about 3–5 minutes.

---

## 0. One-time setup: Git credentials in Workbench

Workbench sessions run on a **remote server**, not your laptop. That means credentials
you have locally don't carry over, so you set them up **inside the Workbench session**.
There are three common methods:

| Method | Clone URL looks like | Best for |
|---|---|---|
| **A. OAuth (browser sign-in)** | `https://github.com/ORG/REPO.git` | Fastest setup with no keys or tokens to copy (recommended for demos) |
| **B. SSH key** | `git@github.com:ORG/REPO.git` | Long-lived, no password prompts |
| **C. HTTPS + Personal Access Token (PAT)** | `https://github.com/ORG/REPO.git` | Works anywhere, including through most proxies |

### Option A — OAuth with the GitHub CLI (run in a Workbench terminal)

Sign in through your browser using GitHub's **device flow**. This works well on a remote
server, because you approve the sign-in on your laptop and the token is stored in the Workbench session.

```bash
gh auth login --hostname github.com --git-protocol https --web
#  → copy the one-time code, open https://github.com/login/device on your laptop,
#    paste the code, and approve
gh auth setup-git      # configures Git to use gh for credentials
gh auth status         # confirm you're logged in
```

That's it. Clone with the HTTPS URL, and push and pull work from **every** IDE (RStudio's Git pane,
Positron, VS Code, JupyterLab), because they all use the same `git`.

**Notes**
- `gh` must be installed on the Workbench server. If it isn't, ask your admin, or put the
  [release binary](https://github.com/cli/cli/releases) in `~/bin`.
- **Other providers:** [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager)
  (installed by an admin) supports the OAuth device flow for GitHub, GitLab, Bitbucket, and Azure DevOps.
  On a headless server, set a credential store, for example `git config --global credential.credentialStore cache`.
- The token is saved in `~/.config/gh/hosts.yml`. On ephemeral storage, run `gh auth login` again in each
  new session. It takes about 20 seconds.
- In a browser-based Workbench session, the **"Sign in with GitHub"** button in VS Code or Positron may not work,
  because the OAuth redirect has to return to the server. Use the terminal flow above.

### Option B — SSH key (run in a Workbench terminal)

```bash
ssh-keygen -t ed25519 -C "you@example.com"   # press Enter to accept defaults
cat ~/.ssh/id_ed25519.pub                    # copy this public key
ssh -T git@github.com                        # test after adding the key to your provider
```

RStudio Pro users can also go to **Tools > Global Options > Git/SVN > Create SSH Key**.

### Option C — HTTPS + PAT

1. Create a PAT with your provider (for GitHub, a fine-grained token with *Contents: Read and write* on this repo).
2. Clone with the HTTPS URL. When Git prompts for a password, paste the **PAT**.

### Where to add keys and tokens

| Provider | SSH Keys | PAT |
|---|---|---|
| GitHub | [Add SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) | [Manage PATs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) |
| GitLab | [Add SSH key](https://docs.gitlab.com/user/ssh/) | [Create PAT](https://docs.gitlab.com/user/profile/personal_access_tokens/) |
| Bitbucket | [Set up SSH keys](https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-linux/) | [Create app password](https://support.atlassian.com/bitbucket-cloud/docs/create-an-app-password/) |
| Azure DevOps | [SSH auth](https://learn.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate) | [Use PATs](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) |

### Tip: persist credentials on ephemeral storage

If your sessions use ephemeral storage (for example, Kubernetes or Slurm), persist HTTPS credentials with:

```bash
git config --global credential.helper 'store --file ~/.my-credentials'
```

> ⚠️ This stores the token in **plain text** in your home directory. Never commit that file;
> it's already listed in this repo's `.gitignore`.

### Set your identity (once per user)

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

### Azure DevOps: delegated credentials (RStudio Pro only)

If your admin has configured **Microsoft Entra ID SSO with delegated permissions**, Workbench
authenticates to Azure DevOps automatically through the `git-credential-pwb` helper.
You don't need a PAT or an SSH key:

```bash
git clone https://dev.azure.com/{organization}/{project}/_git/{repository}
```

This is available **only in RStudio Pro sessions**.

---

## 1. RStudio Pro

**Clone**
1. **File > New Project > Version Control > Git**
2. Paste the repo URL and choose a directory, then select **Create Project**.
   RStudio opens `BrightleafCoffee.Rproj`, and `renv` bootstraps automatically.
3. In the console, run `renv::restore()` to install the R packages.

**Edit → Commit → Push**
1. Open `eda.qmd` and change the plot title or the *Key takeaway* text.
2. Select **Render** to show the report regenerating its own synthetic data.
3. Open the **Git** pane (in the Environment/History/Git tab group).
   - Check **Staged** next to `eda.qmd`, then select **Commit**.
   - Review the diff, write a message, and select **Commit**.
   - Select **Push** (green up arrow).
4. Point out that `data/*.csv` and `eda.html` **don't** appear in the Git pane because `.gitignore` excludes them.

**Terminal option**
- **Tools > Terminal > New Terminal** (or **Alt + Shift + T**):
  ```bash
  git status
  git log --oneline -5
  ```

---

## 2. Positron Pro

**Clone**
1. Open the **Command Palette** (`Ctrl/Cmd + Shift + P`).
2. Search for **Workspaces: New Folder from Git**.
3. Paste the repo URL and choose a parent folder. Positron opens the cloned folder.

**Edit → Commit → Push**
1. Open `eda.ipynb` (Python) or `eda.qmd` (R). Positron handles both.
2. Make a small edit and save.
3. Select the **Source Control** view in the Activity Bar (branch icon on the left).
   - Select a file to see the side-by-side diff.
   - Select **+** to stage, type a message, then select **Commit**.
   - Select **Sync Changes** to push.

**Bonus:** create a branch from the status bar (bottom-left branch name), then select **+ Create new branch…**.

---

## 3. VS Code

**Clone**
- Command Palette → **Git: Clone** → paste the URL.

**Edit → Commit → Push**
1. Run `uv sync` in the terminal (`` Ctrl + ` ``) to create the Python environment.
2. Open `eda.ipynb`, select the `.venv` kernel, and run all cells.
3. Edit the *Key takeaway* cell and save.
4. Open **Source Control** (`Ctrl/Cmd + Shift + G`), then stage, commit, and **Sync Changes**.

**Git Graph extension (recommended)**
1. Open **Extensions** (`Ctrl/Cmd + Shift + X`), then search for **Git Graph** and install it.
2. Select **Git Graph** in the Source Control title bar to see an interactive commit history.
   Right-click a commit to check out, cherry-pick, or create a branch.

---

## 4. JupyterLab

**Install the Git extension** (skip this if your admin has preinstalled it; this repo's `uv` env already includes it):

```bash
python -m pip install --upgrade jupyterlab jupyterlab-git
```

**Clone**
- In the left sidebar, select the **Git** icon, then **Clone a Repository**, and paste the URL.
  (Or use **Git > Clone a Repository** from the menu bar.)

**Edit → Commit → Push**
1. Open `eda.ipynb`, run the cells, and edit the takeaway markdown cell.
2. In the **Git** panel, the notebook appears under **Changed**.
   - Select the file to view a **notebook-aware diff** that compares cells, not raw JSON.
   - Hover over the file and select **+** to stage, enter a summary, then select **Commit**.
   - Select the **Push** (cloud-up) icon in the panel header.

> 💡 Tip: clear outputs before committing (**Edit > Clear Outputs of All Cells**) to keep diffs small.

---

## 5. A "team" moment (optional, about 2 minutes)

Show collaboration across IDEs:

1. **Person or IDE A** (for example, RStudio Pro) edits `_brand.yml` by changing `primary: green` to `primary: orange`, then commits and pushes.
2. **Person or IDE B** (for example, JupyterLab) selects **Pull**. The brand change arrives.
3. Re-render `eda.qmd` to show the new color. The change was one line and one commit, and it shows up everywhere.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `Permission denied (publickey)` | Add the **public** key to your provider; run `ssh -T git@github.com` |
| Git still prompts after `gh auth login` | Run `gh auth setup-git`; make sure the remote URL is `https://`, not `git@` |
| HTTPS asks for a password repeatedly | Use a **PAT**, not your account password; set a `credential.helper` |
| `Author identity unknown` | Set `git config --global user.name/user.email` |
| RStudio Git pane missing | Open the `.Rproj` file; check **Tools > Global Options > Git/SVN** for the Git path |
| Push rejected (`non-fast-forward`) | **Pull** first, then push again |
| JupyterLab has no Git icon | Install `jupyterlab-git` and restart the JupyterLab session |
