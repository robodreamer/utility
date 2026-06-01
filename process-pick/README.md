# process-pick

Interactive cleanup picker for stale local workloads.

`process-pick` shows likely cleanup candidates, lets you select one or more with `fzf`, previews process details, then sends a signal. It is intentionally quieter than `htop` or `btop`: browsers, desktop UI, and common background services are hidden from the default view unless they look unusually hot.

The shell installer also adds the short alias:

```bash
pkp
```

## Usage

```bash
process-pick
pkp
process-pick --full
process-pick --all-users
process-pick --signal INT
process-pick --kill
process-pick --dry-run
process-pick --list
```

Defaults:

- Shows only your own processes.
- Focuses on suspicious dev jobs, agents, local servers, robot processes, and long-running CPU users.
- Hides the owner column and trims long paths/flags to keep the picker readable.
- Uses color only for decisions: reason, CPU heat, and age. Pass `--no-color` for plain output.
- Use `--full` to show a broader non-system process list.
- Skips PID 1, kernel-style bracket processes, and the picker itself.
- Sends `TERM` unless another signal is specified.
- Uses `fzf` when available, with a numbered fallback menu.

## Install

From `~/utility`:

```bash
./install-shell-tools
source ~/.bashrc
```
