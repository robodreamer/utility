# Home utilities

Small CLI helpers kept outside individual project repos.

## `git-park`

Park uncommitted work in a **linked Git worktree** and switch your **primary** clone to `main` (or `master`), without losing track of where the WIP lives. Running it **with no arguments** opens a **one-shot menu** (arrow keys if [fzf](https://github.com/junegunn/fzf) is installed): you pick **one** action, it runs, then the program exits. Run `git park` again for another action.

**Name:** `git-park` is short and matches the main action. If `git-park` is on your `PATH`, Git will run it when you type **`git park …`** (same as any `git-*` helper).

### One-time setup

Put this folder on your `PATH` (Bash example):

```bash
export PATH="$HOME/utility/git-park/bin:$PATH"
```

Add that line to `~/.bashrc` (or your shell’s startup file), then open a new terminal or run `source ~/.bashrc`.

**Optional (recommended):** install **fzf** for ↑↓ selection in menus. Without it, the script uses **numbered prompts** (`1`, `2`, …).

Check:

```bash
command -v git-park
git park help
```

Optional short shell alias — **avoid `gp` on Debian/Ubuntu** (that name is associated with **pari-gp**, and `command-not-found` will nag you to install it):

```bash
alias gpark='git park'
# or: alias gpk='git park'
```

### Repeatable shell setup (Bash)

If you want this to work the same way on another machine, copy this block into `~/.bashrc`:

```bash
# git-park helpers
export PATH="$HOME/utility/git-park/bin:$PATH"

# Base command alias
alias gpark='git park'

# Direct jump aliases (print path via git-park, then cd in current shell)
alias parkcd='cd "$(git park go)"'
alias parkhome='cd "$(git park home)"'

# Day-to-day picker shortcut
alias pgp='park go --pick'

# Wrapper: make `park go` / `park home` perform actual cd
park() {
  case "${1:-}" in
    home)
      shift
      cd "$(git park home "$@")" || return
      ;;
    go)
      shift
      cd "$(git park go "$@")" || return
      ;;
    *)
      git park "$@"
      ;;
  esac
}
```

Reload shell config:

```bash
source ~/.bashrc
```

Quick checks:

```bash
type park
type pgp
git park help
```

### Interactive mode (default)

```bash
cd /path/to/your/repo
git park
# or: git-park
```

Main menu:

- **Park WIP** — prompts for worktree path and stash message, shows a **dry-run** summary, then asks for confirmation before changing anything.
- **Restore** — (1) **Apply or pop a stash** into the **current worktree’s checkout**. After a successful `park`, the stash is usually **already applied** in the linked worktree, so the list is often empty — that is normal; use **git status** there. (2) **Show cd command** lists **`[primary]`** (main clone), **`[last park]`**, other worktrees, and history — **deduplicated** by path. Paste the `cd …` line (clipboard copy is attempted when `wl-copy` / `xclip` / `xsel` / `pbcopy` exists). If you pick the directory you’re already in, the tool says so and skips redundant `cd`.
- **Remove worktree** — pick a non-primary linked worktree and remove it (never removes the primary). Use this to clean up parked or stale worktrees.
- **Status** — worktrees, stashes, last park file, and recent **history** (last parks).
- **Help** / **Quit**

If your cwd is a **linked worktree**, you’ll see a short banner explaining that WIP is usually already there and stashes are often empty.

**`git stash -u`:** the `park` step runs `git stash push -u`, which saves **staged + unstaged + untracked** files, then restores a clean tree so you can check out `main`. Ignored files (per `.gitignore`) stay ignored unless you also use `--all` (git-park does not). See `git help stash`.

### Jump between primary clone and parked worktree (no copy/paste)

A script **cannot** `cd` your interactive shell. It *can* print a path so **your shell** runs `cd`:

**→ Linked worktree (last park):** uses **`wip-worktree-last`**. From **any cwd inside the repo**:

```bash
cd "$(git park go)"
```

**→ Primary (original) clone:** Git’s first worktree is always the main checkout — no need to remember `~/Projects/repos/embodik` vs typos like `embodiK`:

```bash
cd "$(git park home)"
```

Interactive picker (includes **`[primary]`** first, then **`[last park]`**, then other paths):

```bash
cd "$(git park go --pick)"
```

Optional shell shortcuts:

```bash
alias parkcd='cd "$(git park go)"'
alias parkhome='cd "$(git park home)"'
```

Same one-shot menu: `git park menu`, `git park i`, or `git park interactive`.

### Non-interactive commands

| Command | Purpose |
|--------|---------|
| `git park park` | Stash (`-u`), checkout integration branch here, add worktree, stash pop there, record path + history. |
| `git park restore` | Opens only the **Restore** flow (stash or `cd` helper). |
| `git park remove` | Remove a non-primary linked worktree (never the main clone). Supports `--pick` and `--force`. |
| `git park go` | Print **only** the last parked worktree path (stdout) — for `cd "$(git park go)"`. |
| `git park go --pick` | Print path after interactive pick (same options as Restore → Show cd). |
| `git park go /path/to/wt` | Print that path if it’s an existing directory (sanity check). |
| `git park home` | Print **only** the **primary** worktree path — for `cd "$(git park home)"` (back from linked). |
| `git park status` | List worktrees, stashes, last park, recent history. |
| `git park help` | Full CLI text. |

(`git-park park`, `git-park status`, etc. work the same.)

### Typical non-interactive flow

```bash
cd /path/to/my-repo          # primary clone
git switch my-feature        # not main
git park park                # default worktree under ~/git-worktrees/...
cd "$(git park go)"          # into linked WIP
cd "$(git park home)"        # back to primary clone (from worktree or primary)
```

Custom worktree path:

```bash
git park park ~/wt/my-repo-my-feature
```

Preview only:

```bash
git park park -n
```

### State files (per repository, under Git’s shared dir)

| File | Purpose |
|------|---------|
| `wip-worktree-last` | Last park: `WORKTREE_PATH`, branch, etc. |
| `wip-save-history` | Append-only log of parks (newest-first in menus / status tail). |

Safe to delete either file if you don’t need the reminders. (Older stash lines may still say `wip-save park:`; new ones use `git-park:`.)

### Environment

| Variable | Meaning |
|----------|---------|
| `WIP_WORKTREE_ROOT` | Parent directory for the default worktree path when you don’t pass an explicit path. Default: `~/git-worktrees`. |

### If something goes wrong

- **`stash pop` conflicts:** resolve in the worktree directory; then clean up stash if Git left one (`git stash list` / `git stash drop` when appropriate).
- **Target path already exists:** remove or rename that directory, or pass a different `WORKTREE_PATH`.
- **Forgot PATH:** `~/utility/git-park/bin/git-park status` or `~/utility/git-park/bin/git-park`
- **Interactive path editing** uses `read -e` / `read -i` (Bash 4+).

### What “stash” does here

`git stash push -u` saves your working tree and index (and untracked files), then resets the primary clone so you can checkout `main`. The stash is **repository-wide**, so it can be applied with `stash pop` inside the new worktree. **Restore → stash** runs `git stash apply` or `pop` in the **current** repo. See `git help stash`.
