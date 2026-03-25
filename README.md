# Utility Workspace

Personal utility tools live in dedicated subdirectories so new tools can be added without cluttering the root.

## Layout

- `git-park/`
  - `bin/git-park`: executable on your `PATH`
  - `README.md`: usage and shell setup

## PATH

Add tool bins to your shell config (Bash example):

```bash
export PATH="$HOME/utility/git-park/bin:$PATH"
```

Then reload:

```bash
source ~/.bashrc
```
