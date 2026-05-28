# agent-pick

Interactive dispatcher when multiple AI agent CLIs install the same command name (`agent`).

## Install

From the utility workspace root:

```bash
./install-shell-tools
source ~/.bashrc
```

Requires `fzf` for arrow-key selection (optional numbered fallback). Install via `./install-deps`.

## Usage

| Command | Behavior |
|---------|----------|
| `agent` | Show picker when multiple CLIs, then run |
| `agp` | Same as `agent` (always pick unless a default is configured) |
| `cursor-agent` | Cursor Agent CLI directly |
| `grok-agent` | Grok CLI directly |

```bash
agent --help              # picker then Cursor/Grok --help
agent-pick --cursor -p hi # skip picker
agent-pick --list         # show installed backends
```

## Skip the picker (optional)

By default, every `agent` call shows the picker when both CLIs are installed.

To pin a default and skip the menu:

```bash
export AGENT_PICK_DEFAULT=cursor   # or grok
# or: printf '%s\n' cursor > ~/.config/agent-pick/default
```

- Force picker anyway: `agent-pick --pick` (or clear the default)
- Clear saved default: `rm ~/.config/agent-pick/default`
