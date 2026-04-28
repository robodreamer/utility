# git-recent

`git-recent` lists local branches in recently used order and can switch to the selected branch.

If `git-recent` is on your `PATH`, Git runs it as:

```bash
git recent
```

## Install

```bash
export PATH="$HOME/utility/git-recent/bin:$PATH"
```

Optional but recommended: install [`fzf`](https://github.com/junegunn/fzf) for arrow-key selection. Without `fzf`, the tool falls back to a numbered prompt.

## Usage

```bash
git recent                 # picker, then git switch <branch>
git recent pick            # same
git recent switch BRANCH   # switch to BRANCH, or show its worktree path
git recent list            # colorful list
git recent list --no-color # plain list
git recent help
```

Branches first appear by local HEAD reflog checkout/switch history, newest first. For each switch, the branch you just left is shown before the branch you switched to, which makes the picker better for returning to recent work. The interactive picker omits the current branch; `git recent list` includes it with a `*` marker. Branches not found in checkout history are appended by tip commit date.

If the selected branch is already checked out in another worktree, `git-recent` does not call `git switch`. It resolves the existing worktree path, using `git park go` when available, and prints a `cd` suggestion. The `grecent` shell function in `~/.bashrc` uses the same path mode to jump there automatically.

This history is local to your clone and can expire with normal Git reflog cleanup.
