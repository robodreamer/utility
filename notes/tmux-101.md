# tmux 101

tmux keeps terminal sessions running in the background. You can close Ghostty,
reconnect later, and continue where you left off—including long-running coding
agents, servers, and builds.

## Start or reconnect

Start a session named `main`, or reconnect if it already exists:

```bash
tmux new-session -A -s main
```

The options mean:

- `new-session` — create a new tmux session.
- `-s main` — name the session `main` (`-s` means **session name**).
- `-A` — attach to `main` if it already exists instead of creating a duplicate
  (`-A` means **attach if available**).

In plain English: **“Open my `main` session, creating it if necessary.”** This
makes the command safe to run every time you open Ghostty.

See running sessions:

```bash
tmux ls
```

Attach to a specific session:

```bash
tmux attach -t main
```

For unrelated projects, use separate named sessions instead of putting
everything in `main`:

```bash
tmux new-session -A -s website
tmux new-session -A -s backend
```

## The prefix key

Most controls begin with the **prefix**, `Ctrl-b`.

Press `Ctrl-b`, release both keys, then press the command key. For example,
to detach, press `Ctrl-b`, release, then press `d`.

## Essential controls

| Keys | Action |
|---|---|
| `Ctrl-b d` | Detach and leave everything running |
| `Ctrl-b ?` | Show all keybindings; press `q` to close |
| `Ctrl-b r` | Reload your tmux configuration |

### Windows

Windows are like terminal tabs.

| Keys | Action |
|---|---|
| `Ctrl-b c` | Create a window in the current directory |
| `Ctrl-b n` | Go to the next window |
| `Ctrl-b p` | Go to the previous window |
| `Ctrl-b 1` … `9` | Go directly to a numbered window |
| `Ctrl-b ,` | Rename the current window |
| `Ctrl-b &` | Close the current window after confirmation |
| `Ctrl-b w` | Open the window and pane chooser |

### Panes

Panes split one window into multiple terminals.

| Keys | Action |
|---|---|
| `Ctrl-b \|` | Split left/right |
| `Ctrl-b -` | Split top/bottom |
| `Ctrl-b h/j/k/l` | Move left/down/up/right |
| `Ctrl-b o` | Move to the next pane |
| `Ctrl-b z` | Zoom or unzoom the current pane |
| `Ctrl-b x` | Close the current pane after confirmation |
| `Ctrl-b Space` | Cycle through pane layouts |

You can also click panes and drag their borders because mouse support is enabled.

## Scroll and copy

Use the mouse wheel to scroll, or enter copy mode with:

```text
Ctrl-b [
```

In copy mode:

| Key | Action |
|---|---|
| Arrow keys / Page Up / Page Down | Navigate history |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Repeat the search |
| `q` | Exit copy mode |

Your configuration keeps 100,000 lines of history per pane. With mouse mode
enabled, tmux handles mouse selection and scrolling; hold `Shift` while
selecting if you want Ghostty to handle the selection directly.

## A simple agent workflow

1. Open Ghostty.
2. Run `tmux new-session -A -s main`.
3. Start an agent in the first pane.
4. Use `Ctrl-b |` for a side pane with tests or logs.
5. Use `Ctrl-b c` for another project or agent.
6. Detach with `Ctrl-b d` when leaving.
7. Reconnect later with the same `tmux new-session -A -s main` command.

## Session management

Rename the current session:

```text
Ctrl-b $
```

From a normal shell, stop a specific session and its processes:

```bash
tmux kill-session -t main
```

Only use `kill-session` when you are finished—detaching is what preserves your
work. Similarly, `exit` closes the current shell and pane, and closing the last
pane ends the session. `Ctrl-b x` closes a pane and terminates its processes.

Attaching to the same session from another terminal exposes the same live
workspace to both terminals; input from either client controls it.

## Important limitations

- tmux survives a closed terminal, logout, or dropped SSH connection, but it
  does not survive a machine reboot.
- tmux preserves processes, terminal output, panes, and working directories. It
  does not protect unsaved editor buffers from a reboot or crash.
- When working remotely, run tmux **after** connecting over SSH so the tmux
  server and its processes live on the remote machine.
- Avoid accidentally nesting tmux sessions. Run `echo "$TMUX"`; a nonempty
  result means you are already inside tmux.
- Configuration changes do not automatically affect existing servers. Reload
  the configuration with `Ctrl-b r`.

## Mental model

```text
tmux server
└── session: main
    ├── window 1
    │   ├── pane 1: coding agent
    │   └── pane 2: tests or logs
    └── window 2
        └── pane 1: shell
```

- **Server:** the background tmux process that keeps everything alive.
- **Session:** a reconnectable workspace.
- **Window:** a tab inside a session.
- **Pane:** a split terminal inside a window.

Your configuration lives at `~/.tmux.conf`.
