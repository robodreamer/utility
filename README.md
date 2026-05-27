# Utility Workspace

Personal utility tools live in dedicated subdirectories so new tools can be added without cluttering the root.

## Layout

- `git-park/`
  - `bin/git-park`: executable on your `PATH`
  - `README.md`: usage and shell setup
- `giftool/`
  - `bin/giftool`: GIF trim/resize CLI
  - `bin/giftool-gui`: lightweight desktop UI for trimming, scrubbing, previewing, and resizing GIFs
  - `README.md`: usage and setup
- `git-recent/`
  - `bin/git-recent`: executable on your `PATH`
  - `README.md`: recently used branch picker
- `caffeinate-lid/`
  - `bin/caffeinate-lid`: keep a Linux/systemd laptop awake, including with the lid closed
  - `README.md`: usage and setup

## PATH

Install optional dependencies first:

```bash
./install-deps
```

This installs `fzf` when it is missing, which enables arrow-key selection in `git park` and `git recent` menus. Use `./install-deps --check` to only report dependency status, or `./install-deps --dry-run` to print the install command.

Install or refresh the shell setup automatically:

```bash
./install-shell-tools
source ~/.bashrc
```

The installer adds a managed block to `~/.bashrc` for `git park`, `git recent`, ClipFlip/GIF tools, and `caffeinate-lid`. It is safe to rerun; the managed block is replaced instead of duplicated.

Add tool bins to your shell config (Bash example):

```bash
export PATH="$HOME/utility/git-park/bin:$HOME/utility/git-recent/bin:$PATH"
export PATH="$HOME/utility/giftool/bin:$PATH"
export PATH="$HOME/utility/caffeinate-lid/bin:$PATH"
```

Then reload:

```bash
source ~/.bashrc
```
