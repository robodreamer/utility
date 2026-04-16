# giftool

Small helpers for trimming and resizing existing animated GIFs without depending on the broken `gifcurry` snap build.

## Contents

- `bin/giftool`: CLI wrapper around system `ffmpeg`
- `bin/giftool-gui`: Tk desktop UI for scrubbing, trim selection, preview, and render

## Setup

Add the tool bin directory to your shell `PATH`:

```bash
export PATH="$HOME/utility/giftool/bin:$PATH"
```

Reload your shell:

```bash
source ~/.bashrc
```

## CLI

```bash
giftool -i input.gif -o output.gif -s 1.2 -d 2.5 -w 480
giftool -i input.gif -o output.gif -e 3.0 -h 240 -f 12
```

Supported options:

- trim by `--start`, `--end`, or `--duration`
- resize by `--width` and/or `--height`
- frame rate control with `--fps`
- loop count with `--loop`

The CLI uses a palette generation pass to keep GIF quality acceptable after trimming or resizing.

## GUI

Launch:

```bash
giftool-gui
```

Features:

- open an animated GIF from the current working directory or home
- preview and scrub through frames
- play, pause, previous, next, and jump-to-trim controls
- trim with start and end sliders
- resize by pixels or percentage
- source and output size display
- output resize capped at `100%` to avoid upscaling
- render output GIF through the same CLI backend

## Dependencies

- `ffmpeg`
- Python 3
- `tkinter`
- Pillow (`PIL`)
- optional: `ffplay` for external preview
