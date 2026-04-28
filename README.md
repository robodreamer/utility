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

## PATH

Add tool bins to your shell config (Bash example):

```bash
export PATH="$HOME/utility/git-park/bin:$HOME/utility/git-recent/bin:$PATH"
export PATH="$HOME/utility/giftool/bin:$PATH"
```

Then reload:

```bash
source ~/.bashrc
```
