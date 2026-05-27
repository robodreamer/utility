# caffeinate-lid

`caffeinate-lid` keeps a Linux/systemd laptop awake, including when the lid is closed.

It starts a background `systemd-inhibit` process with:

```text
sleep:idle:handle-lid-switch
```

That blocks normal sleep, idle suspend, and lid-close suspend while the mode is on. It does not permanently edit `/etc/systemd/logind.conf`.

## Install

Put this tool on your `PATH`:

```bash
export PATH="$HOME/utility/caffeinate-lid/bin:$PATH"
```

Or, from the root of this utility repo, install the managed shell setup:

```bash
./install-shell-tools
source ~/.bashrc
```

Check:

```bash
command -v caffeinate-lid
caffeinate-lid status
```

## Usage

```bash
caffeinate-lid on       # block sleep and lid-close suspend
caffeinate-lid status   # show active inhibitor
caffeinate-lid off      # allow sleep again
caffeinate-lid restart  # restart the inhibitor process
```

State is stored under:

```text
~/.cache/caffeinate-lid/
```

## Notes

- Requires Linux with `systemd-inhibit`.
- No sudo is required for the inhibitor mode.
- The setting lasts until `caffeinate-lid off`, reboot, logout/session cleanup, or the background process exits.
- Some firmware or desktop environments may still react differently to lid close on low battery, thermal events, or docking state.

## Verify

After turning it on:

```bash
systemd-inhibit --list
```

You should see an entry similar to:

```text
sleep infinity ... sleep:idle:handle-lid-switch ... caffeinate-lid mode is enabled ... block
```
